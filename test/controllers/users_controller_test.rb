require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.find(1)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { admin: @user.admin, firstname: @user.firstname, lastname: @user.lastname, username: @user.username } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should not create user for user without admin acess" do
    # set user that doesn't have admin access
    @user = User.find(10)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "not_admin", :mail => "username10@nowhere.com"})
    assert_no_difference('User.count') do
      post users_url, params: { user: { admin: @user.admin, firstname: @user.firstname, lastname: @user.lastname, username: @user.username } }
    end
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { admin: false }}
    assert_redirected_to user_url(@user)
    @user = User.find(1)
    assert_equal false, @user.admin, "admin should be false"
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
