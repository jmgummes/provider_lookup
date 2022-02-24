class ClinicTaxonomyEdge < ApplicationRecord
  belongs_to :clinic
  belongs_to :clinic_taxonomy
end
