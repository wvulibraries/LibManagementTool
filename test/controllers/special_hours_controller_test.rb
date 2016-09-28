require 'test_helper'

class SpecialHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @special_hour = special_hours(:one)
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
    patch special_hour_url(@special_hour), params: { special_hour: { close_time: @special_hour.close_time, end_date: @special_hour.end_date, name: @special_hour.name, no_close_time: @special_hour.no_close_time, no_open_time: @special_hour.no_open_time, open_24: @special_hour.open_24, open_time: @special_hour.open_time, start_date: @special_hour.start_date } }
    assert_redirected_to special_hour_url(@special_hour)
  end

  test "should destroy special_hour" do
    assert_difference('SpecialHour.count', -1) do
      delete special_hour_url(@special_hour)
    end

    assert_redirected_to special_hours_url
  end
end
