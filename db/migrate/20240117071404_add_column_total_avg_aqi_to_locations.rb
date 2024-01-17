class AddColumnTotalAvgAqiToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :avg_aqi, :float
  end
end
