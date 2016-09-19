class DropLibraryCol < ActiveRecord::Migration[5.0]
  def change
    remove_column :libraries , :hasDepartment
  end
end
