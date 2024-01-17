require "test_helper"
require "uri"
require "json"
require "net/http"

class LocationTest < ActiveSupport::TestCase

  test "get correct aqi success" do
    location = locations(:London)
    url = URI("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{location.latitude}&lon=#{location.longitude}&appid=#{OpenWeatherMap::API_KEY}")
    parsed_response = api_call(url)

    assert parsed_response['list'][0]['main']['aqi'] >= 0
  end

  test "cannot create a location without a name" do
    location = Location.new
    assert_not location.save
  end

  test "cannot make api call with invalid api key" do
    location = locations(:London)
    incorrect_api_key = 'wrongkey124'
    url = URI("#{OpenWeatherMap::AIR_POLLUTION_URI}?lat=#{location.latitude}&lon=#{location.longitude}&appid=#{incorrect_api_key}")
    parsed_response = api_call(url)
    
    assert_equal(401, parsed_response['cod'])
  end

  test "successful geocoding response" do
    location = locations(:Varanasi)
    url = URI("#{OpenWeatherMap::GEOCODING_DATA_URI}?q=#{location.name}&limit=1&appid=#{OpenWeatherMap::API_KEY}")
    parsed_response = api_call(url)
    
    assert_equal(location.state, parsed_response[0]['state'])
  end

  test "no location data for invalid city" do
    location = locations(:Dummy)
    url = URI("#{OpenWeatherMap::GEOCODING_DATA_URI}?q=#{location.name}&limit=1&appid=#{OpenWeatherMap::API_KEY}")
    parsed_response = api_call(url)
    
    assert_not parsed_response.nil?
  end

  def api_call(url, *arg)
    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    parsed_response = JSON.parse(response.body)
  end
end
