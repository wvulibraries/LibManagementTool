class CreateSpecialHours < ActiveRecord::Migration[5.0]
  def change
    create_table :special_hours do |t|
      t.references :special, polymorphic: true, index: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :name
      t.datetime :open_time
      t.datetime :close_time
      t.boolean :open_24
      t.boolean :no_close_time
      t.boolean :no_open_time
      t.timestamps
    end
  end
end
