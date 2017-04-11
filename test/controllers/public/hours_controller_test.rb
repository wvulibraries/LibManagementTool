require 'test_helper'

class Public::HoursControllerTest < ActionDispatch::IntegrationTest
  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get hours_url
    assert_response :success
  end
end
