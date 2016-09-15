class LinkedTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :departments
    create_table :departments do |t|
      t.string :name
      t.text :description
      t.belongs_to :library, index: true
      t.timestamps
    end
  end
end
