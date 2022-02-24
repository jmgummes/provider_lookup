class PhysicianTaxonomy < ApplicationRecord
  validates :code, presence: true, uniqueness: true
end
