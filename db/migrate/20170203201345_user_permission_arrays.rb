class UserPermissionArrays < ActiveRecord::Migration[5.0]
  def change
    drop_table(:user_permissions, if_exists: true)
    create_table :user_permissions do |t|
      t.text :departments
      t.text :libraries
      t.string :username
      t.timestamps
    end
  end
end
