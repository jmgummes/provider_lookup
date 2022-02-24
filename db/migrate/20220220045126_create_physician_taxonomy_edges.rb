class CreatePhysicianTaxonomyEdges < ActiveRecord::Migration[7.0]
  def change
    create_table :physician_taxonomy_edges do |t|
      t.integer :physician_id, null: false
      t.integer :physician_taxonomy_id, null: false
      t.boolean :primary, null: true
      t.string :state, null: true
      t.string :license, null: true
      t.timestamps
      t.index [:physician_id, :physician_taxonomy_id, :state, :license], unique: true, name: "phys_tax_edges_ids_index"
    end
  end
end
