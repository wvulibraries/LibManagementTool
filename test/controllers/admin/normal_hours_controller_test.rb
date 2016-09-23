require 'test_helper'

class Admin::NormalHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_normal_hour = admin_normal_hours(:one)
  end

  test "should get index" do
    get admin_normal_hours_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_normal_hour_url
    assert_response :success
  end

  test "should create admin_normal_hour" do
    assert_difference('Admin::NormalHour.count') do
      post admin_normal_hours_url, params: { admin_normal_hour: {  } }
    end

    assert_redirected_to admin_normal_hour_url(Admin::NormalHour.last)
  end

  test "should show admin_normal_hour" do
    get admin_normal_hour_url(@admin_normal_hour)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_normal_hour_url(@admin_normal_hour)
    assert_response :success
  end

  test "should update admin_normal_hour" do
    patch admin_normal_hour_url(@admin_normal_hour), params: { admin_normal_hour: {  } }
    assert_redirected_to admin_normal_hour_url(@admin_normal_hour)
  end

  test "should destroy admin_normal_hour" do
    assert_difference('Admin::NormalHour.count', -1) do
      delete admin_normal_hour_url(@admin_normal_hour)
    end

    assert_redirected_to admin_normal_hours_url
  end
end
