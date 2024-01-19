require 'sidekiq-scheduler'

class AirQualityImporter < ApplicationJob

  def perform(*args)
    Location.all.each do |location|
      air_quality_data = OpenWeatherMap.fetch_air_quality(location)

      tranformed_data = transform(air_quality_data, location)
      if !tranformed_data.nil?
        save_to_database(tranformed_data)
      else
        puts "No response for #{location.name}"
      end
    end
  end

end
