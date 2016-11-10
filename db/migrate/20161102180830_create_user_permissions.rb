class CreateUserPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_permissions do |t|
      t.timestamps
    end
  end
end
