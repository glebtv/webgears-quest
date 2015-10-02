class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :domain
      t.string :url

      t.timestamps null: false
    end
  end
end
