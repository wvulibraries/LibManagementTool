require 'test_helper'

class Admin::UserPermissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user_permission = admin_user_permissions(:one)
  end

  test "should get index" do
    get admin_user_permissions_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_user_permission_url
    assert_response :success
  end

  test "should create admin_user_permission" do
    assert_difference('Admin::UserPermission.count') do
      post admin_user_permissions_url, params: { admin_user_permission: { departments: @admin_user_permission.departments, libraries: @admin_user_permission.libraries, username: @admin_user_permission.username } }
    end

    assert_redirected_to admin_user_permission_url(Admin::UserPermission.last)
  end

  test "should show admin_user_permission" do
    get admin_user_permission_url(@admin_user_permission)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_permission_url(@admin_user_permission)
    assert_response :success
  end

  test "should update admin_user_permission" do
    patch admin_user_permission_url(@admin_user_permission), params: { admin_user_permission: { departments: @admin_user_permission.departments, libraries: @admin_user_permission.libraries, username: @admin_user_permission.username } }
    assert_redirected_to admin_user_permission_url(@admin_user_permission)
  end

  test "should destroy admin_user_permission" do
    assert_difference('Admin::UserPermission.count', -1) do
      delete admin_user_permission_url(@admin_user_permission)
    end

    assert_redirected_to admin_user_permissions_url
  end
end
