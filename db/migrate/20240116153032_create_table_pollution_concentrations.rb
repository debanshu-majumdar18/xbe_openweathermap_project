class CreateTablePollutionConcentrations < ActiveRecord::Migration[7.1]
  def change
    create_table :pollution_concentrations do |t|
      t.references :location, null: false, foreign_key: true
      t.float :pm25
      t.float :pm10
      t.float :co
      t.float :o3
      t.float :so2
      t.float :no2
      t.float :aqi

      t.timestamps
    end
  end

end
