require "rails_helper"

RSpec.describe DnsRecordsController, type: :routing do
  describe "routing" do
    it "routes to #search" do
      expect(:get => "/dns_records/search").to route_to("dns_records#search")
    end

    it "routes to #create" do
      expect(:post => "/dns_records").to route_to("dns_records#create")
    end
  end
end
