class Location < ApplicationRecord
  validates_presence_of :name  

  #avg air quality index per month(or total if false passed) per location
  def get_avg_aqi(monthly=true)
    total_aqi = 0
    self.pollution_concentration.each_with_index do |p, idx|
      break if idx >= (24*30) && monthly #assuming that the aqi call is made once an hour 24*30 for per month
      total_aqi += p['aqi']
    end
    total_aqi/self.pollution_concentration.count.to_f
  end

  #returns {<state>: <avg AQI from all cities>}
  def self.get_avg_aqi_for_state
    result = {}
    Location.all.group_by(&:state).each do |st|
      
      total_aqi = total_records =  0
      st[1][0]['pollution_concentration'].each do |city|
        total_aqi += city['aqi'] || 0
        total_records += 1
      end
      aqi_for_state = total_aqi/total_records.to_f
      result[st[0]] = aqi_for_state
    end
    result
  end


  #model method to update pollution concentrations after POLLUTION api callback
  def save_pollution_data(data)
    if data.present?
      info = create_data_hash(data)
      existing_data = self.pollution_concentration || []
      existing_avg_aqi = self.avg_aqi || 0

      res = existing_data << info
      self.update(pollution_concentration: res)
      avg_aqi = (existing_avg_aqi+data['list'][0]['main']['aqi'])/self.pollution_concentration.count.to_f
      self.update(avg_aqi: avg_aqi)
    else
      puts "Error in updating Air Quality data for -> #{self.name}"
    end
  end

  #model method to update lon, lat etc. after GEOCODING api callback
  def save_geocoding_data(data)
    if self.update(longitude: data[0]['lon'], latitude: data[0]['lat'],state: data[0]['state'], country: data[0]['country'])
      puts "Updated city #{self.name} \n"
    else
      puts "Error for city #{self.name} \n"
    end
  end

  #model method to update historic data after HISTORIC api callback
  def save_historic_data(data)
    if data.present?
      info = create_data_hash(data)
      existing_data = self.historic_data || []
      res = existing_data << info
      self.update(historic_data: res)
    else
      puts "Error in updating Air Quality data for -> #{self.name}"
    end
  end

  #Helper method
  def create_data_hash(data)
    info = { 'aqi': data['list'][0]['main']['aqi'], 'pm25': data['list'][0]['components']['pm2_5'],
    'pm10': data['list'][0]['components']['pm10'], 'o3': data['list'][0]['components']['o3'], 
    'no2': data['list'][0]['components']['no2'], 'co': data['list'][0]['components']['co'], 
    'so2': data['list'][0]['components']['so2'], 'date': Time.at(data['list'][0]['dt']).to_datetime.utc} 
  end

  def get_status(aqi)
    return ['text-success', 'Good'] if aqi <= 1
    return ['text-primary', 'Moderate'] if aqi <= 3
    return ['text-warning', 'Poor'] if aqi <= 4
    return ['text-danger', 'Very Poor'] if aqi > 4
  end

end
