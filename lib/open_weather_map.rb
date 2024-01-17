require "uri"
require "json"
require "net/http"

class OpenWeatherMap

  API_KEY = '8e0d56047fc0f6000ce0176f09b07570'.freeze

  AIR_POLLUTION_URI = 'http://api.openweathermap.org/data/2.5/air_pollution'
  GEOCODING_DATA_URI = 'http://api.openweathermap.org/geo/1.0/direct'
  HISTORICAL_DATA_URI = 'http://api.openweathermap.org/data/2.5/air_pollution/history'

  def initialize(api_key)
    @api_key = api_key
  end

  private

  #API call to pollution API
  def fetch_air_quality(location_id)
    location = set_location(location_id)
    city_name, lon, lat = location.name, location.longitude, location.latitude
    url = URI("#{AIR_POLLUTION_URI}?lat=#{lat}&lon=#{lon}&appid=#{API_KEY}")
    parsed_response = api_call(url)

    if parsed_response.present? && parsed_response['code'] != "400"
      location.save_pollution_data(parsed_response)
      puts "Updated Air Quality data for -> #{city_name}"
    else
      puts "Error for #{lat} #{lon} -> #{city_name}"
    end

  end

  #API call to GEOCODING API
  def fetch_geocoding_data(location_id)
    location = set_location(location_id)
    city_name = location.name
    url = URI.parse("#{GEOCODING_DATA_URI}?q=#{CGI.escape(city_name)}&limit=1&appid=#{API_KEY}")
    parsed_response = api_call(url)
    
    if parsed_response.present?
      location.save_geocoding_data(parsed_response)
    end
  end

  #API call to HISTORIC API
  def fetch_monthly_historical_data(location_id)
    location = set_location(location_id)
    lat = location.latitude
    lon = location.longitude

    st = (Time.now-1.month).utc.to_i
    en = Time.now.utc.to_i 
    url = URI.parse("#{HISTORICAL_DATA_URI}?lat=#{lat}&lon=#{lon}&start=#{st}&end=#{en}&appid=#{API_KEY}")
    parsed_response = api_call(url)

    if parsed_response.present?
      location.save_historic_data(parsed_response)
    end
  end

  #Helper method
  def api_call(url, *arg)
    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    parsed_response = JSON.parse(response.body)
  end

  #Setter method
  def set_location(id)
    location = Location.find_by(id: id)
  end


end
