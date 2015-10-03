class CreateLogLines < ActiveRecord::Migration
  def change
    create_table :log_lines do |t|
      t.string :user_ip
      t.string :request_time
      t.string :request_content
      t.string :response_status
      t.string :response_weight
      t.string :user_info
      t.belongs_to :log
      t.timestamps null: false
    end
  end
end
