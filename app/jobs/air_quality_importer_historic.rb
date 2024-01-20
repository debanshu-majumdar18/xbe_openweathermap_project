require 'sidekiq-scheduler'

class AirQualityImporterHistoric < ApplicationJob

  def perform(*args)
    Location.all.each do |location|
      period_in_days = Location::DEFAULT_PERIOD_IN_DAYS
      air_quality_data = OpenWeatherMap.fetch_historical_data(location, period_in_days)

      unless air_quality_data.nil?
        transformed_data_array = transform_historic(air_quality_data, location)
        save_to_database_historic(transformed_data_array, location)
      else
        puts "No response for #{location.name}"
      end
    end
  end

end