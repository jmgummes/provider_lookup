require 'uri'
require 'net/http'
require 'json'

class NPIRegistryAPIDriver
  include Singleton
  
  def get_provider(npi)
    uri = URI("https://npiregistry.cms.hhs.gov/api/")
    params = {version: "2.1", number: npi}
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    response = http.request(req)
    return response, nil, nil unless response.is_a?(Net::HTTPSuccess)
    json = JSON.parse(response.body)
    results = json["results"]
    return response, false, json unless results.is_a?(Array) && results.length == 1 
    return response, true, results.first
  end
end
