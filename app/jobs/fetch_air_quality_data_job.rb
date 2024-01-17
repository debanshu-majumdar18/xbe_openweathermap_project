require 'sidekiq-scheduler'

class FetchAirQualityDataJob < ApplicationJob

  def perform(*args)
    puts "Updating AQI data at #{Time.now}"
    openweathermap_obj = OpenWeatherMap.new(OpenWeatherMap::API_KEY)

    Location.all.each do |location|
      openweathermap_obj.send(:fetch_air_quality, location.id)
    end
  end
end
