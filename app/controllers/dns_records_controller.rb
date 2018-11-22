class DnsRecordsController < ApplicationController
  # Returns DNS records and their hostnames.
  # This endpoint should accept:
  #  ● A list of hostnames the results should include (optional parameter)
  #  ● A list of hostnames the results should exclude (optional parameter)
  #  ● A page number (required)
  def search
    render json: DnsRecord.search(search_params)
  end

  # Creates a DNS record and it’s associated hostnames.
  # This endpoint should accept an IPv4 IP address and a list of hostnames.
  # The response should return the ID of the DNS record created.
  def create
    dns_record = DnsRecord.new(dns_record_params.slice(:ipv4_address))
    if dns_record.save
      dns_record_params[:hostnames].reject(&:blank?).each do |hostname|
        dns_record.hostnames << Hostname.find_or_create_by(name: hostname)
      end
      render json: { ID: dns_record.id }, status: :created
    else
      render json: { errors: dns_record.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  private

    # Only allow a trusted parameter "white list" through.
    def dns_record_params
      params.require(:dns_record).permit(:ipv4_address, hostnames: [])
    end

    def search_params
      params.require(:search).permit(:page_number,
        included_hostnames: [], excluded_hostnames: [])
    end
end
