require 'rails_helper'
require_relative '../../app/services/open_weather_map.rb'

RSpec.describe OpenWeatherMap, type: :request do
  before { @location_with_cord = create(:location, latitude: 28, longitude: 27) }
  before { @pollution_response = OpenWeatherMap.fetch_air_quality(@location_with_cord) }

  before { @location_new = create(:location) }
  before { @geocoding_response = OpenWeatherMap.fetch_geocoding_data(@location_new.name) }

  before { @historic_response = OpenWeatherMap.fetch_historical_data(@location_with_cord, 60) }

  describe "GET /air_pollution" do
    it "returns pollution concentrations for a location" do
      expect(@pollution_response['list'][0]['main']['aqi']).to be >= 0
    end

    it "returns atleast one element's pollution concentration" do
      expect(@pollution_response['list'][0]['components']['co']).to be >= 0
    end
  end

  describe "GET /geocoding_data" do
    it "returns the longitude & latitude for a location" do
      expect(@geocoding_response[:latitude].class).to eql(Float)
      expect(@geocoding_response[:longitude].class).to eql(Float)
    end
  end

  describe "GET /historical_data" do
    context "for a given time frame" do
      it "returns historic pollution concentrations for a location" do
        expect(@historic_response['list'][0]['main']['aqi']).to be >= 0
      end
    end
  end

end