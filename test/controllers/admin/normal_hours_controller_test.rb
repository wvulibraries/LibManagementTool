require 'test_helper'

class Admin::NormalHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @normal_hour = NormalHour.find(2)
    @user = User.find(1)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get normal_hours_url
    assert_response :success
  end

  test "should get new" do
    get new_normal_hour_url
    assert_response :success
  end

  test "should create normal_hour" do
    assert_difference('NormalHour.count') do
      # Cannot save an identical record adding 1 to set another resource
      id = @normal_hour.resource_id + 1
      post normal_hours_url, params: { normal_hour: { resource_type: @normal_hour.resource_type, resource_id: id, day_of_week: @normal_hour.day_of_week, open_time: @normal_hour.open_time, close_time: @normal_hour.close_time } }
    end

    assert_redirected_to normal_hour_url(NormalHour.last)
  end

  test "should show normal_hour" do
    get normal_hour_url(@normal_hour)
    assert_response :success
  end

  test "should get edit" do
    get edit_normal_hour_url(@normal_hour)
    assert_response :success
  end

  test "should update normal_hour" do
    # increase open_time by 1 hour
    new_open_time = @normal_hour.open_time + 60*60
    patch normal_hour_url(@normal_hour), params: { normal_hour: { open_time: new_open_time } }
    assert_redirected_to normal_hour_url(@normal_hour), "this did not redirect properly"
    @normal_hour.reload
    assert_equal new_open_time,  @normal_hour.open_time, "open_time was not equal for new open_time"
  end

  test "should destroy normal_hour" do
    assert_difference('NormalHour.count', -1) do
      delete normal_hour_url(@normal_hour)
    end

    assert_redirected_to normal_hours_url
  end
end
