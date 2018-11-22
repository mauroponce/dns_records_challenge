class CreateHostnameDnsRecordAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :hostname_dns_record_associations do |t|
      t.references :dns_record, foreign_key: true
      t.references :hostname, foreign_key: true

      t.timestamps
    end
  end
end
