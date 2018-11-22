class DnsRecord < ApplicationRecord
  # Associations
  has_many :hostname_dns_record_associations
  has_many :hostnames, through: :hostname_dns_record_associations

  # Validations
  validate :valid_ipv4_address

  # IPAddr takes '' as '0.0.0.0', set nil instead, as invalid.
  def ipv4_address
    super.present? ? IPAddr.new(super, Socket::AF_INET).to_s : nil
  end

  # Store IP as integer
  def ipv4_address=(ip_addr)
    ip_addr = (IPAddr.new(ip_addr) rescue nil)
    super(ip_addr)
  end

  # Class Methods
  def self.search(opts = {})
    included_hostnames = opts[:included_hostnames]
    excluded_hostnames = opts[:excluded_hostnames]

    ids_containing_included = dns_record_ids_by_hostnames(included_hostnames)
    ids_containing_excluded = dns_record_ids_by_hostnames(excluded_hostnames)

    matching_dns_ids = ids_containing_included - ids_containing_excluded

    dns_records = DnsRecord.includes(:hostnames).where(id: matching_dns_ids)

    # hostnames returned by the search
    search_hostnames = dns_records.map{ |dns| dns.hostnames.map(&:name) }.flatten

    # excluding any hostnames specified in the query
    ret_hostnames = search_hostnames - included_hostnames - excluded_hostnames

    # group hostnames by count
    # => {"lorem.com"=>1, "amet.com"=>2}
    hostnames = ret_hostnames.uniq.map { |x| [x, ret_hostnames.count(x)] }.
      map{ |hn| "Hostname: #{hn[0]}, Number of matching DNS records: #{hn[1]}" }

    result_dns_records = dns_records.map{ |dns| {ID: dns.id, IP: dns.ipv4_address} }
    {
      dns_records_number: result_dns_records.size,
      dns_records: result_dns_records,
      hostnames: hostnames
    }
  end

  # Private Methods
  private

  # Validate ip address format and uniqueness when creating or updating a record.
  def valid_ipv4_address
    parsed_ip = (IPAddr.new(ipv4_address) rescue nil)

    if parsed_ip.try(:ipv4?)
      if DnsRecord.where(ipv4_address: parsed_ip.to_i).where.not(id: self.id).exists?
        return errors.add(:ipv4_address, 'is already taken.')
      end
    else
      return errors.add(:ipv4_address, 'is not a valid IPv4 address')
    end
  end

  def self.dns_record_ids_by_hostnames(hostnames)
    DnsRecord.joins(:hostnames).
      where("hostnames.name IN (?)", hostnames).
      having("count(distinct hostnames.name) = ?", hostnames.length).
      group('id').
      pluck('id')
  end
end
