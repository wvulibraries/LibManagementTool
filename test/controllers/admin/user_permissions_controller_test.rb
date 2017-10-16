require 'test_helper'

class Admin::UserPermissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user_permission = UserPermission.find(1)
    @user = User.find(1)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get user_permissions_url
    assert_response :success
  end

  test "should get new" do
    get new_user_permission_url
    assert_response :success
  end

  test "should get edit" do
    get edit_user_permission_url @admin_user_permission
    assert_response :success
  end

  test "should create user_permission" do
    assert_difference('UserPermission.count') do
      post user_permissions_url, params: { user_permission: { departments: @admin_user_permission.departments, libraries: @admin_user_permission.libraries, username: @admin_user_permission.username } }
    end

    assert_redirected_to user_permission_url UserPermission.last
  end

  test "should show user_permission" do
    get user_permission_url(@admin_user_permission)
    assert_response :success
  end

  test "should update user_permission" do
    patch user_permission_url(@admin_user_permission), params: { user_permission: { departments: @admin_user_permission.departments, libraries: @admin_user_permission.libraries, username: @admin_user_permission.username } }
    assert_redirected_to user_permission_url(@admin_user_permission)
  end

  test "should destroy user_permission" do
    assert_difference('UserPermission.count', -1) do
      delete user_permission_url(@admin_user_permission)
    end

    assert_redirected_to user_permissions_url
  end

  test "should not allow non-admin users" do
    @user = User.find(10)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "not_admin", :mail => "username10@nowhere.com"})
    get user_permission_url(@admin_user_permission)
    assert_redirected_to user_permissions_url
  end
end
