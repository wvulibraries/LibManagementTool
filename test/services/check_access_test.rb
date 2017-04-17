require 'test_helper'

class CheckAccessTest < ActiveSupport::TestCase
  def setup
    @user = User.find(1)
    credentials = { sn: 'Admin', mail: 'username1@nowhere.com' }
    CASClient::Frameworks::Rails::Filter.fake(@user.username, credentials)
  end

  # called after every single test
  teardown do
    Rails.cache.clear
  end

  test 'test should set user libs using attr_accessor' do
    array_libs = [1, 2, 3, 4]
    check_access = CheckAccess.new
    check_access.libs = array_libs
    assert_equal check_access.libs.length, array_libs.length,  "test failed because length of items didn't match'"
  end

  test 'should set user_depts in @check_access' do
    array_depts = [1, 2, 3]
    check_access = CheckAccess.new
    check_access.depts = array_depts
    assert_equal check_access.depts.length, array_depts.length, "test failed because length of items didn't match'"
  end

end
