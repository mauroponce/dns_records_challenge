HostnameDnsRecordAssociation.delete_all
Hostname.delete_all
DnsRecord.delete_all

lorem = Hostname.create(name: "lorem.com")
ipsum = Hostname.create(name: "ipsum.com")
dolor = Hostname.create(name: "dolor.com")
amet  = Hostname.create(name: "amet.com")
sit   = Hostname.create(name: "sit.com")

dns1 = DnsRecord.create(ipv4_address: "1.1.1.1")
dns1.hostnames << lorem
dns1.hostnames << ipsum
dns1.hostnames << dolor
dns1.hostnames << amet

dns2 = DnsRecord.create(ipv4_address: "2.2.2.2")
dns2.hostnames << ipsum

dns3 = DnsRecord.create(ipv4_address: "3.3.3.3")
dns3.hostnames << ipsum
dns3.hostnames << dolor
dns3.hostnames << amet

dns4 = DnsRecord.create(ipv4_address: "4.4.4.4")
dns4.hostnames << ipsum
dns4.hostnames << dolor
dns4.hostnames << sit
dns4.hostnames << amet

dns5 = DnsRecord.create(ipv4_address: "5.5.5.5")
dns5.hostnames << dolor
dns5.hostnames << sit
