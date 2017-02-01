class UpdateUsersInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :firstname, :string, null: false
    add_column :users, :lastname, :string, null: false
  end
end
