require "json"
require "httparty"

class OpenWeatherMap
  include HTTParty

  AIR_POLLUTION_URI = 'http://api.openweathermap.org/data/2.5/air_pollution'
  GEOCODING_DATA_URI = 'http://api.openweathermap.org/geo/1.0/direct'
  HISTORICAL_DATA_URI = 'http://api.openweathermap.org/data/2.5/air_pollution/history'

  def self.fetch_geocoding_data(city_name)
    response = call_api_and_log(GEOCODING_DATA_URI, 'geo', {q: city_name, limit: 1}, 'GET')

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
    lon, lat = location.longitude, location.latitude
    response = call_api_and_log(AIR_POLLUTION_URI, 'curr_pollution', {lat: lat, lon: lon}, 'GET')

    return nil unless response.success?
    parsed_response = JSON.parse(response.body)
  end

  def self.fetch_historical_data(location, period_in_days = 365)
    lat, lon = location.latitude, location.longitude
    start_time, end_time = (Time.now-period_in_days.days).utc.to_i, Time.now.utc.to_i 
    response = call_api_and_log(HISTORICAL_DATA_URI, 'historic_pollution', {lat: lat, lon: lon, start: start_time, end: end_time}, 'GET')

    return nil unless response.success?
    parsed_response = JSON.parse(response.body)
  end

  private

  def self.call_api_and_log(url, name, params, type)
    params[:appid] = ENV['API_KEY']
    response = get(url, query: params)
    ApiCallLog.create(api_name: name, api_end_point: url, params: params.to_s, request_type: type, callback: response)
    response
  end

end
