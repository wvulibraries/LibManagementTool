require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should clean the array removing nil items" do
    test_array = [nil, '']
    @controller = ApplicationController.new
    assert_equal [], @controller.clean_array(test_array)
  end

  test "an empty array returns an empty array" do
    test_array = []
    @controller = ApplicationController.new
    assert_equal [], @controller.clean_array(test_array)
  end


  test "that an array with a non empty item, and an realistic item returns correct length" do
    test_array = [nil, 1, 2, 3]
    compare_array = [1,2,3]
    @controller = ApplicationController.new
    assert_equal compare_array.length, @controller.clean_array(test_array).length
  end
end
