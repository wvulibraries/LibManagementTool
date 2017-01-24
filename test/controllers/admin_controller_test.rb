require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    CASClient::Frameworks::Rails::Filter.fake('username1', {:role => 'username', :email => "username1@mail.wvu.edu"})
    get admin_url
    assert_response :success
    assert_equal flash[:success] = "Welcome #{@username}!  You have been sucessfully logged in!"
  end

  test "assert user has been logged in and assigned to the @username variable" do
    CASClient::Frameworks::Rails::Filter.fake('username1', {:role => 'username', :email => "username1@mail.wvu.edu"})
    get admin_url
    assert_not_nil assigns(:username)
  end

  test "flash message success has been given and the user has been fully logged in" do
    CASClient::Frameworks::Rails::Filter.fake('username1', {:role => 'username', :email => "username1@mail.wvu.edu"})
    get admin_url
    username = assigns(:username)
    assert_equal flash[:success] = "Welcome #{username}!  You have been sucessfully logged in!"
  end

  test "" do
     CASClient::Frameworks::Rails::Filter.fake("frank", {:role => "user", :email => "frank@mail.wvu.edu"})
     get admin_url
     assert_redirected_to root_path
  end

  test "should fail permissions check and be re-directed to the root_path, show a flash message that user doesn't have permissions" do
     CASClient::Frameworks::Rails::Filter.fake("frank", {:role => "user", :email => "frank@mail.wvu.edu"})
     get admin_url
     assert_redirected_to root_path
     assert_equal flash[:error] = 'You do not have administrative permissions, please contact the system administrator if you feel that this has been reached in error.'
  end

  test "should not login because not cas user is present, show a flash message error that a faulty login was detected" do
    CASClient::Frameworks::Rails::Filter.fake("frank", {:role => "user", :email => "frank@mail.wvu.edu"})
    get admin_url
    assert_redirected_to root_path
    assert_equal flash[:error] 'Something went wrong or a faulty login was detected.'
  end
end
