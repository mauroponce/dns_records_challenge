require 'rails_helper'

RSpec.describe "DnsRecords", type: :request do

  describe "POST /dns_records" do
    subject(:create_dns_record) do
      post '/dns_records', params: { dns_record: dns_params }
    end

    context "when params are valid" do
      context "when there are no hostnames" do
        let(:dns_params) { attributes_for(:dns_record, hostnames: []) }

        it "returns the DNS record ids" do
          create_dns_record
          expect(json_response).to have_key('ID')
          expect(response).to have_http_status(:created)
        end
      end

      context "when there are hostnames" do
        let(:dns_params) do
          attributes_for(:dns_record).merge({
            hostnames: 3.times.map { Faker::Internet.domain_name }
          })
        end

        it "returns the DNS record ids" do
          create_dns_record
          expect(json_response).to have_key('ID')
          expect(response).to have_http_status(:created)
        end
      end
    end

    context "when params are not valid" do
      context "when IP param is not a valid IPv4 address" do
        let(:dns_params) { attributes_for(:dns_record, ipv4_address: '') }
        it "returns IP not valid error message" do
          create_dns_record
          expect(json_response['errors']).to eq(['Ipv4 address is not a valid IPv4 address'])
        end
      end

      context "when IP is already taken" do
        before do
          create(:dns_record, ipv4_address: '127.0.0.1')
        end

        let(:dns_params) { attributes_for(:dns_record, ipv4_address: '127.0.0.1') }
        it "returns IP already taken error message" do
          create_dns_record
          expect(json_response['errors']).to eq(['Ipv4 address is already taken.'])
        end
      end
    end
  end

  describe "GET /dns_records/search" do
    before do
      # Load example data from assginment
      lorem = create(:hostname, name: "lorem.com")
      ipsum = create(:hostname, name: "ipsum.com")
      dolor = create(:hostname, name: "dolor.com")
      amet  = create(:hostname, name: "amet.com")
      sit   = create(:hostname, name: "sit.com")

      dns1 = create(:dns_record, ipv4_address: "1.1.1.1")
      dns1.hostnames << lorem
      dns1.hostnames << ipsum
      dns1.hostnames << dolor
      dns1.hostnames << amet

      dns2 = create(:dns_record, ipv4_address: "2.2.2.2")
      dns2.hostnames << ipsum

      dns3 = create(:dns_record, ipv4_address: "3.3.3.3")
      dns3.hostnames << ipsum
      dns3.hostnames << dolor
      dns3.hostnames << amet

      dns4 = create(:dns_record, ipv4_address: "4.4.4.4")
      dns4.hostnames << ipsum
      dns4.hostnames << dolor
      dns4.hostnames << sit
      dns4.hostnames << amet

      dns5 = create(:dns_record, ipv4_address: "5.5.5.5")
      dns5.hostnames << dolor
      dns5.hostnames << sit
    end

    subject(:search) do
      get '/dns_records/search', params: { search: search_params }
    end

    context "when there are matching records" do
      let(:search_params) do
        {
          page_number: 10,
          included_hostnames: ["ipsum.com", "dolor.com"],
          excluded_hostnames: ["sit.com"]
        }
      end

      it "returns expected response" do
        search
        expect(json_response['dns_records_number']).to eq(2)
        expect(json_response['dns_records']).to eq(
          [{"ID"=>1, "IP"=>"1.1.1.1"}, {"ID"=>3, "IP"=>"3.3.3.3"}]
        )
        expect(json_response['hostnames']).to eq([
          "Hostname: lorem.com, Number of matching DNS records: 1",
          "Hostname: amet.com, Number of matching DNS records: 2"
        ])
      end
    end

    context "when there are no matching records" do
      let(:search_params) do
        {
          page_number: 10,
          included_hostnames: ["google.com", "tesla.com"],
          excluded_hostnames: ["microsoft.com"]
        }
      end

      it "returns expected response" do
        search
        expect(json_response['dns_records_number']).to eq(0)
        expect(json_response['dns_records']).to be_empty
        expect(json_response['hostnames']).to be_empty
      end
    end
  end
end
