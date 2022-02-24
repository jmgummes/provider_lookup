class CreatePhysicianTaxonomies < ActiveRecord::Migration[7.0]
  def change
    create_table :physician_taxonomies do |t|
      t.string :code, null: false
      t.string :description, null: true
      t.timestamps
    end
  end
end
