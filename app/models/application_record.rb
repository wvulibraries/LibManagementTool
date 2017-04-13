# Active Record base for datamodels
# @author David J. Davis
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
