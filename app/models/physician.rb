require 'orderable'

class Physician < ApplicationRecord
  include Orderable
  
  has_many :physician_taxonomy_edges
  has_many :physician_taxonomies, through: :physician_taxonomy_edges
  
  validates :number, presence: true, uniqueness: true
  
  def self.create_from_registry_data!(data)
    physician = build_physician_from_registry_data(data)
    build_taxonomy_edges_from_registry_data(data, physician)
    physician.save!    
  end

  def primary_taxonomy_edge
    physician_taxonomy_edges.find {|t| t.primary? }
  end
  
  def primary_taxonomy
    primary_taxonomy_edge&.physician_taxonomy
  end

  private

  def self.build_physician_from_registry_data(data)
    attributes = { 
      order: (Physician.minimum(:order) || 1) - 1,
      number: data["number"]
    }
    
    attributes.merge!(basic_attributes(data))
    
    [:location, :mailing].each_with_index do |prefix, i|
      attributes.merge!(address_attributes(data["addresses"][i], prefix))
    end
    
    Physician.new(attributes)  
  end


  def self.basic_attributes(data)
    fields = [
      :name_prefix, :first_name, :last_name, :middle_name, :credential,
      :sole_propieter, :gender, :status
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

  def self.build_taxonomy_edges_from_registry_data(data, physician)
    taxonomy_map = build_taxonomy_map(data["taxonomies"]) 
    data["taxonomies"].each do |taxonomy|
      physician.physician_taxonomy_edges.new(
        primary: taxonomy["primary"],
        state: taxonomy["state"],
        license: taxonomy["license"],
        physician_taxonomy: taxonomy_map[taxonomy["code"]]
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
    PhysicianTaxonomy.find_by_code(data["code"]) ||
    PhysicianTaxonomy.new(code: data["code"], description: data["desc"])
  end
end
