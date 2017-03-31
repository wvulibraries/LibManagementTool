require 'test_helper'

class Admin::SpecialHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @special_hour = SpecialHour.find(1)
    @user = User.find(1)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get special_hours_url
    assert_response :success
  end

  test "should get new" do
    get new_special_hour_url
    assert_response :success
  end

  test "should create special_hour" do
    assert_difference('SpecialHour.count') do
      post special_hours_url, params: { special_hour: { close_time: @special_hour.close_time, end_date: @special_hour.end_date, name: @special_hour.name, no_close_time: @special_hour.no_close_time, no_open_time: @special_hour.no_open_time, open_24: @special_hour.open_24, open_time: @special_hour.open_time, start_date: @special_hour.start_date } }
    end

    assert_redirected_to special_hour_url(SpecialHour.last)
  end

  test "should show special_hour" do
    get special_hour_url(@special_hour)
    assert_response :success
  end

  test "should get edit" do
    get edit_special_hour_url(@special_hour)
    assert_response :success
  end

  test "should update special_hour" do
    # increase open_time by 1 hour
    new_start_date = @special_hour.start_date + 1.day
    patch special_hour_url(@special_hour), params: { special_hour: { start_date: new_start_date } }
    assert_redirected_to special_hour_url(@special_hour), "this did not redirect properly"
    @special_hour.reload
    assert_equal new_start_date,  @special_hour.start_date, "start_date was not equal for new start_date"
  end

  test "should destroy special_hour" do
    assert_difference('SpecialHour.count', -1) do
      delete special_hour_url(@special_hour)
    end

    assert_redirected_to special_hours_url
  end
end
