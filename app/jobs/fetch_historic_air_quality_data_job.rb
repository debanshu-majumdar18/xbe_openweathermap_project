require 'sidekiq-scheduler'

class FetchHistoricAirQualityDataJob < ApplicationJob

  def perform(*args)
    puts "Updating Historic AQI data at #{Time.now}"
    openweathermap_obj = OpenWeatherMap.new(OpenWeatherMap::API_KEY)

    Location.all.each do |location|
      openweathermap_obj.send(:fetch_monthly_historical_data, location.id)
    end
  end
end
