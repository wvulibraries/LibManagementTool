require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    CASClient::Frameworks::Rails::Filter.fake('username1', {:role => 'username', :email => "username1@mail.wvu.edu"})
    get admin_url
    assert_response :success
  end

  test "assert user has been logged in and assigned to the @username variable then also logout" do
    CASClient::Frameworks::Rails::Filter.fake('username1', {:role => 'username', :email => "username1@mail.wvu.edu"})
    get admin_url
    assert_not_nil assigns(:username)
    get admin_logout_url
    assert_nil assigns(:username)
  end

  test "assume that user does not exist, no credentials" do
     CASClient::Frameworks::Rails::Filter.fake("frank", {:role => "user", :email => "frank@mail.wvu.edu"})
     get admin_url
     assert_redirected_to root_path
  end

  test "should fail permissions check and be re-directed to the root_path" do
     CASClient::Frameworks::Rails::Filter.fake("frank", {:role => "user", :email => "frank@mail.wvu.edu"})
     get admin_url
     assert_redirected_to root_path
  end

end
