class UpdateNormalHours < ActiveRecord::Migration[5.0]
  def change
    create_table :normal_hours do |t|
      t.references :resource, polymorphic: true, index: true
      t.integer :day_of_week
      t.datetime :open_time
      t.datetime :close_time
      t.timestamps
    end
  end
end
