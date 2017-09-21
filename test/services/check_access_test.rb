require 'test_helper'

class CheckAccessTest < ActiveSupport::TestCase
  def setup
    @user = User.find(1)
    credentials = { sn: 'Admin', mail: 'username1@nowhere.com' }
    CASClient::Frameworks::Rails::Filter.fake(@user.username, credentials)

    @user_non_admin = User.find(10)
  end

  # called after every single test
  teardown do
    Rails.cache.clear
  end

  test 'should allow you to set the user on initialize' do
    check_access = CheckAccess.new('test')
    assert_not_nil check_access.user, 'user was nil and not set'
    assert_equal check_access.user, 'test', 'user was not set on initialize'
  end

  test 'should allow you to set the read/write the user' do
    check_access = CheckAccess.new('test')
    check_access.user = 'user1'
    assert_equal check_access.user, 'user1', 'the user attribute did not set'
  end

  test 'should not allow a user not in the database to be instantiated' do 
    check_access = CheckAccess.new('test')
    assert_not check_access.valid?, 'user is not a valid user in the database' 
  end 

  test 'should override the user that was created on init' do
    check_access = CheckAccess.new('test')
    check_access.user = 'user1'
    assert_not_equal check_access.user, 'test', 'the user was set to the initialize and not modified'
  end

  test 'should not allow the user to be nil' do
    check_access = CheckAccess.new(nil)
    assert_not check_access.valid? 'it allowed the user to be nil'
  end

  test 'should check if the user exists for base level access' do
    check_access = CheckAccess.new(@user.username)
    assert check_access.permission?, 'user did not have permission but should have had permission'
  end

  test 'should check if the user is an admin getting true' do
     check_access = CheckAccess.new(@user.username)
     assert check_access.admin?, 'user was an admin should return true'
  end

  test 'should check if the user is an admin getting false' do
    check_access = CheckAccess.new(@user_non_admin.username) 
    assert_not check_access.admin?, 'user was not an admin should return false'
  end

  test 'allows you to read the users library permissions' do
    check_access = CheckAccess.new(@user_non_admin.username)
    assert_equal check_access.libraries, [1,2], 'the array didn\'t match the fixtures'
  end

  test 'allows you to read the users department permissions' do
    check_access = CheckAccess.new(@user_non_admin.username)
    assert_equal check_access.departments, [1,2], 'the array didn\'t match the fixtures'
  end 
end
