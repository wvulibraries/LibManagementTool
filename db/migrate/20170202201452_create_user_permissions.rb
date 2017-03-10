class CreateUserPermissions < ActiveRecord::Migration[5.0]
  def change
    drop_table(:user_permissions, if_exists: true)
    create_table :user_permissions do |t|
      t.string :building_type
      t.integer :building_id, :limit => 2
      t.string :username
      t.timestamps
    end
  end
end
