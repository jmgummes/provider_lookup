class ClinicTaxonomy < ApplicationRecord
  validates :code, presence: true, uniqueness: true
end
