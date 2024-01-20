class Location < ApplicationRecord
  has_many :pollution_concentrations
  has_many :historic_data_record

  validates_presence_of :name  

  DEFAULT_PERIOD_IN_DAYS = 60

  def average_air_quality_index(period_in_days = 30)
    PollutionConcentration
    .where(location: self)
    .where('created_at >= ?', period_in_days.days.ago)
    .group(:location_id)
    .average(:aqi).values.first
  end

  def self.average_aqi_by_state
    Location.includes(:pollution_concentrations).group(:state).average('pollution_concentrations.aqi')
  end

  def status_of(aqi)
    return ['text-success', 'Good'] if aqi <= 1
    return ['text-primary', 'Moderate'] if aqi <= 3
    return ['text-warning', 'Poor'] if aqi <= 4
    return ['text-danger', 'Very Poor'] if aqi > 4
  end

end