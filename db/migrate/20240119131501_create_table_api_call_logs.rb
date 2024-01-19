class CreateTableApiCallLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :api_call_logs do |t|
      t.string :api_end_point
      t.string :api_name
      t.string :params
      t.string :request_type
      t.string :callback
      
      t.timestamps
    end
  end
end
