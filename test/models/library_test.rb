require 'test_helper'

class LibraryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "can not save library without a name" do
    library = Library.new
    assert_not = library.save, "Saved without a name"
  end 
end
