class ApplicationJob < ActiveJob::Base
  
  private
  
  def transform(air_quality_data, location)
     create_data_hash(air_quality_data, location)
  end

  def transform_historic(air_quality_data, location)
    result = []
    air_quality_data.each_with_index do |item, idx|
      result << create_data_hash(air_quality_data, location, idx)
    end
    result
  end

  def save_to_database(transformed_data)
    return 'Error while saving' unless PollutionConcentration.create(transformed_data)
  end

  def save_to_database_historic(transformed_data, location)
    return 'Error while saving' unless HistoricDataRecord.create(location: location, historic_air_pollution_data: transformed_data)
  end

  def create_data_hash(air_quality_data, location, index = 0)
    { 
      aqi: air_quality_data['list'][index]['main']['aqi'], pm25: air_quality_data['list'][index]['components']['pm2_5'],
      pm10: air_quality_data['list'][index]['components']['pm10'], o3: air_quality_data['list'][index]['components']['o3'], 
      no2: air_quality_data['list'][index]['components']['no2'], co: air_quality_data['list'][index]['components']['co'], 
      so2: air_quality_data['list'][index]['components']['so2'], location: location
     }
  end

end
