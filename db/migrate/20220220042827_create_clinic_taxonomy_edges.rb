class CreateClinicTaxonomyEdges < ActiveRecord::Migration[7.0]
  def change
    create_table :clinic_taxonomy_edges do |t|
      t.integer :clinic_id, null: false
      t.integer :clinic_taxonomy_id, null: false
      t.boolean :primary, null: true
      t.string :state, null: true
      t.string :license, null: true
      t.timestamps
      t.index [:clinic_id, :clinic_taxonomy_id, :state, :license], unique: true, name: "clinic_tax_edges_ids_index"
    end
  end
end
