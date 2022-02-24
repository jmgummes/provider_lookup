require 'orderable'

class Clinic < ApplicationRecord
  include Orderable

  has_many :clinic_taxonomy_edges
  has_many :clinic_taxonomies, through: :clinic_taxonomy_edges
  
  validates :number, presence: true, uniqueness: true

  def self.create_from_registry_data!(data)
    clinic = build_clinic_from_registry_data(data)
    build_taxonomy_edges_from_registry_data(data, clinic)
    clinic.save!    
  end
  
  def primary_taxonomy_edge
    clinic_taxonomy_edges.find {|t| t.primary? }
  end
  
  def primary_taxonomy
    primary_taxonomy_edge&.clinic_taxonomy
  end

  private

  def self.build_clinic_from_registry_data(data)
    attributes = { 
      order: (Clinic.minimum(:order) || 1) - 1,
      number: data["number"]
    }
    
    attributes.merge!(basic_attributes(data))
    
    [:location, :mailing].each_with_index do |prefix, i|
      attributes.merge!(address_attributes(data["addresses"][i], prefix))
    end
    
    Clinic.new(attributes)  
  end


  def self.basic_attributes(data)
    fields = [
      :name, :organizational_subpart, :status, :authorized_official_first_name,
      :authorized_official_last_name, :authorized_official_telephone_number,
      :authorized_official_title_or_position, :authorized_official_name_prefix    
    ]
    
    Hash[
      fields.map {|f| [f, data["basic"][f.to_s]] }
    ]
  end

  def self.address_attributes(data, prefix)
    fields = [
      :country_code, :type, "1".to_sym, "2".to_sym, :city, :state, 
      :postal_code, :telephone_number, :fax_number
    ]
  
    special_mappings = {
      :type => :address_type,
      "1".to_sym => :address_1,
      "2".to_sym => :address_2
    }
  
    Hash[
      fields.map { |f| ["#{prefix}_address_#{f}".to_sym, data[(special_mappings[f] || f).to_s]] }
    ]
  end

  def self.build_taxonomy_edges_from_registry_data(data, clinic)
    taxonomy_map = build_taxonomy_map(data["taxonomies"])
    data["taxonomies"].each do |taxonomy|
      clinic.clinic_taxonomy_edges.new(
        primary: taxonomy["primary"],
        state: taxonomy["state"],
        license: taxonomy["license"],
        clinic_taxonomy: taxonomy_map[taxonomy["code"]]
      )
    end 
  end
  
  def self.build_taxonomy_map(data)
    unique_taxonomies = data.uniq { |t| t["code"] }
    Hash[
      unique_taxonomies.map do |t|
        [t["code"], find_or_build_taxonomy_from_registry_data(t)]
      end
    ]
  end
  
  def self.find_or_build_taxonomy_from_registry_data(data)
    ClinicTaxonomy.find_by_code(data["code"]) ||
    ClinicTaxonomy.new(code: data["code"], description: data["desc"])
  end
end
