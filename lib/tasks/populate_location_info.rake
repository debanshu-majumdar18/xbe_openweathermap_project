namespace :populate do
  task location_info: :environment do 
    openweathermap_obj = OpenWeatherMap.new(OpenWeatherMap::API_KEY)

    Location.all.each do |location|
      openweathermap_obj.send(:fetch_geocoding_data, location.id)
    end
  end
end