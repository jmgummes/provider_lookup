class PhysicianTaxonomyEdge < ApplicationRecord
  belongs_to :physician
  belongs_to :physician_taxonomy
end
