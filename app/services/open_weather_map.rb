require "json"
require "httparty"

class OpenWeatherMap
  include HTTParty

  AIR_POLLUTION_URI = 'http://api.openweathermap.org/data/2.5/air_pollution'
  GEOCODING_DATA_URI = 'http://api.openweathermap.org/geo/1.0/direct'
  HISTORICAL_DATA_URI = 'http://api.openweathermap.org/data/2.5/air_pollution/history'

  def self.fetch_geocoding_data(city_name)
    response = get("#{GEOCODING_DATA_URI}?q=#{CGI.escape(city_name)}&limit=1&appid=#{ENV['API_KEY']}")
    api_log(GEOCODING_DATA_URI, 'geo', "{q: #{city_name}}", 'get', response.body)

    return nil unless response.success?
    parsed_response = JSON.parse(response.body)

    {
     state: parsed_response[0]['state'], 
     country: parsed_response[0]['country'],
     latitude:  parsed_response[0]['lat'],
     longitude:  parsed_response[0]['lon']
    }
  end

  def self.fetch_air_quality(location)
    city_name, lon, lat = location.name, location.longitude, location.latitude
    response = get("#{AIR_POLLUTION_URI}?lat=#{lat}&lon=#{lon}&appid=#{ENV['API_KEY']}")
    api_log(AIR_POLLUTION_URI, 'curr_pollution', "{lat: #{lat}, lon: #{lon}}", 'get', response.body)

    return nil unless response.success?

    parsed_response = JSON.parse(response.body)
  end

  def self.fetch_historical_data(location, period_in_days = 365)
    latititude, longitude = location.latitude, location.longitude
    start_time, end_time = (Time.now-period_in_days.days).utc.to_i, Time.now.utc.to_i 

    response = get("#{HISTORICAL_DATA_URI}?lat=#{latititude}&lon=#{longitude}&start=#{start_time}&end=#{end_time}&appid=#{ENV['API_KEY']}")
    api_log(HISTORICAL_DATA_URI, 'historic', "{lat: #{latititude}, lon: #{longitude}, start: #{start_time}, end: #{end_time}}", 'get', response)

    return nil unless response.success?

    parsed_response = JSON.parse(response.body)
  end

  private

  def self.api_log(url, name, params, type, response)
    ApiCallLog.create(api_name: name, api_end_point: url, params: params, request_type: type, callback: response)
  end

end
