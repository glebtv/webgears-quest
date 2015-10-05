class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string  :domain
      t.string  :url
      t.integer :log_lines_count, default: 0
      t.timestamps null: false
    end
  end
end
