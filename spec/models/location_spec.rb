require 'rails_helper'

RSpec.describe Location do
  let(:location) { Location.new }
  before { @location_delhi = create(:location) }

  describe "#create" do 
    it "cannot create a location without a name" do  
      location.save
      expect(location.errors[:name]).to include("can't be blank")
    end
  end

  describe "#average_air_quality_index" do
    context "for a time period of 10 days" do
      it "calculates the average aqi for a location" do
        create_list(:pollution_concentration, 10, location: @location_delhi, aqi: 4)
        expect(@location_delhi.average_air_quality_index(10).to_f).to eql(4.0)
      end
    end

    context "with no time period given" do
      it "calculates the average aqi for a location" do
        create_list(:pollution_concentration, 20, location: @location_delhi, aqi: 4)
        expect(@location_delhi.average_air_quality_index.to_f).to eql(4.0)
      end
    end
  end

  describe ".average_aqi_by_state" do
    context "for every state" do
      it "calculates the average air quality index" do
        create_list(:pollution_concentration, 5, location: @location_delhi, aqi: 2)
        create_list(:pollution_concentration, 5, location: @location_delhi, aqi: 3)

        expect(Location.average_aqi_by_state[@location_delhi.name]).to eql(2.5)
      end
    end
  end

  describe "#status" do
    it "returns the air quality status of a location" do
      create(:pollution_concentration, location: @location_delhi, aqi: 3)
      aqi = @location_delhi.pollution_concentrations.first.aqi

      expect(@location_delhi.status(aqi).second).to eql('Moderate')
    end
  end

end
