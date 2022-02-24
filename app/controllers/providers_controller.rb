require "npi_registry_api_driver"

class ProvidersController < ApplicationController
  def index
  end
  
  def find
    return unless require_npi
    return unless validate_npi_format
    return if find_clinic_internally
    return if find_physician_internally
    find_provider_externally
  end

  def physicians
    providers(Physician, :physician_taxonomy_edges, :physician_taxonomy) do |p|
      [
        p.number, "#{p.last_name}, #{p.first_name}", p.credential, "#{p.location_address_1}\n#{p.location_address_2}",
        p.location_address_city, p.location_address_state, p.location_address_postal_code, p.location_address_country_code,
        p.primary_taxonomy&.code, p.primary_taxonomy&.description, p.primary_taxonomy_edge&.state, p.primary_taxonomy_edge&.license
      ]
    end
  end
  
  def clinics
    providers(Clinic, :clinic_taxonomy_edges, :clinic_taxonomy) do |c| 
      [
        c.number, c.name, "#{c.authorized_official_last_name}, #{c.authorized_official_first_name}",
        c.authorized_official_title_or_position, "#{c.location_address_1}\n#{c.location_address_2}",
        c.location_address_city, c.location_address_state, c.location_address_postal_code, c.location_address_country_code,
        c.primary_taxonomy&.code, c.primary_taxonomy&.description, c.primary_taxonomy_edge&.state, c.primary_taxonomy_edge&.license
      ]
    end
  end
  
  private

  def providers(model, taxonomy_edges, taxonomy)
    records = model.order(:order).offset(params[:start]).limit(params[:length]).includes({taxonomy_edges => taxonomy}).all
    total = model.count
    render json: {
      draw: params[:draw].to_i,
      recordsTotal: total,
      recordsFiltered: total,
      data: records.map { |r| yield(r) }     
    }
  end
  
  def require_npi
    if params[:npi].blank?
      render_error(400, "Provider number is required.")
      return false
    end
    
    true
  end
  
  def validate_npi_format
    unless params[:npi].length == 10 && params[:npi].first != "0" && (0..9).all? { |i| params[:npi][i] =~ /[[:digit:]]/ }
      render_error(400, "The provider number is malformed.")
      return false   
    end
    
    true
  end
  
  def find_clinic_internally
    internal_clinic = Clinic.find_by_number(params[:npi])
    unless internal_clinic.nil?
      internal_clinic.move_to_top!
      render_success("clinic")
      return true
    end
    
    false 
  end
  
  def find_physician_internally
    internal_physician = Physician.find_by_number(params[:npi])
    unless internal_physician.nil?
      internal_physician.move_to_top!
      render_success("physician")
      return true
    end
    
    false
  end
  
  def find_provider_externally
    response, success, parsed_response = NPIRegistryAPIDriver.instance.get_provider(params[:npi])
    
    unless response.is_a?(Net::HTTPSuccess)
      render_error(500, "NPI lookup failed with unexpected response code of #{response.code}. Response body: #{response.body}")
      return
    end
    
    unless success
      render_error(400, "Provider number is invalid.")
      return
    end
    
    if parsed_response["enumeration_type"] == "NPI-2"
      create_clinic(parsed_response)
      return
    end
    
    create_physician(parsed_response)
  end
  
  def create_clinic(data)
    Clinic.create_from_registry_data!(data)
    render_success("clinic")
  end
  
  def create_physician(data)
    Physician.create_from_registry_data!(data)
    render_success("physician")  
  end
  
  def render_success(provider_type)
    render json: {provider_type: provider_type}
  end
  
  def render_error(code, message)
    render json: {error: message}, status: code
  end
end
