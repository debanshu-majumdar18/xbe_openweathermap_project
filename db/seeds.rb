# The data can then be loaded with the rake db:seed


cities_in_india = ['Mumbai', 'Delhi', 'Bangalore', 'Kolkata', 'Chennai', 'Hyderabad', 'Ahmedabad', 'Pune', 'Surat', 'Jaipur', 'Lucknow', 'Kanpur', 'Nagpur', 'Indore', 'Thane', 'Bhopal', 'Visakhapatnam', 'Patna', 'Vadodara', 'Ghaziabad']
puts "Creating cities... \n"
cities_in_india.each do |city_name|
  geocoding_data = OpenWeatherMap.fetch_geocoding_data(city_name)
  Location.find_or_create_by(name: city_name, latitude: geocoding_data[:latitude], longitude: geocoding_data[:longitude], 
  state: geocoding_data[:state], country: geocoding_data[:country])
end

