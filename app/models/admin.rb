# Adds Namespacing to the Admin models. 
# @author David J. Davis
module Admin
  def self.table_name_prefix
    'admin_'
  end
end
