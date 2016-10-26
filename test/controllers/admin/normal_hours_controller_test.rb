# require 'test_helper'
#
# class Admin::NormalHoursControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @normal_hour = normal_hours(:one)
#   end
#
#   test "should get index" do
#     get normal_hours_url
#     assert_response :success
#   end
#
#   test "should get new" do
#     get new_normal_hour_url
#     assert_response :success
#   end
#
#   test "should create normal_hour" do
#     assert_difference('Admin::NormalHour.count') do
#       post normal_hours_url, params: { normal_hour: {  } }
#     end
#
#     assert_redirected_to normal_hour_url(Admin::NormalHour.last)
#   end
#
#   test "should show normal_hour" do
#     get normal_hour_url(@normal_hour)
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get edit_normal_hour_url(@normal_hour)
#     assert_response :success
#   end
#
#   test "should update normal_hour" do
#     patch normal_hour_url(@normal_hour), params: { normal_hour: {  } }
#     assert_redirected_to normal_hour_url(@normal_hour)
#   end
#
#   test "should destroy normal_hour" do
#     assert_difference('Admin::NormalHour.count', -1) do
#       delete normal_hour_url(@normal_hour)
#     end
#
#     assert_redirected_to normal_hours_url
#   end
# end
