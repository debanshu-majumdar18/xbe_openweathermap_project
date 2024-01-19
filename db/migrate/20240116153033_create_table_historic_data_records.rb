class CreateTableHistoricDataRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :historic_data_records do |t|
      t.references :location, null: false, foreign_key: true
      t.jsonb :historic_air_pollution_data

      t.timestamps
    end
  end

end
