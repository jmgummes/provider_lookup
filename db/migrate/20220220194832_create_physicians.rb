class CreatePhysicians < ActiveRecord::Migration[7.0]
  def change
    create_table :physicians do |t|
      t.integer :order, null: false
      t.integer :number, null: false
      t.string :name_prefix, null: true
      t.string :first_name, null: true
      t.string :last_name, null: true
      t.string :middle_name, null: true
      t.string :credential, null: true
      t.string :sole_propieter, null: true
      t.string :gender, null: true
      t.string :status, null: true
      t.string :location_address_country_code, null: true
      t.string :location_address_type, null: true
      t.string :location_address_1, null: true
      t.string :location_address_2, null: true
      t.string :location_address_city, null: true
      t.string :location_address_state, null: true
      t.string :location_address_postal_code, null: true
      t.string :location_address_telephone_number, null: true
      t.string :location_address_fax_number, null: true
      t.string :mailing_address_country_code, null: true
      t.string :mailing_address_type, null: true
      t.string :mailing_address_1, null: true
      t.string :mailing_address_2, null: true
      t.string :mailing_address_city, null: true
      t.string :mailing_address_state, null: true
      t.string :mailing_address_postal_code, null: true
      t.string :mailing_address_telephone_number, null: true
      t.string :mailing_address_fax_number, null: true
      t.timestamps
      t.index :order, unique: true
      t.index :number, unique: true
    end
  end
end
