class CreateDnsRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :dns_records do |t|
      t.integer :ipv4_address

      t.timestamps
    end
  end
end
