require 'test_helper'

class CheckAccessTest < ActiveSupport::TestCase
  def setup
    @user = User.find(1)
    @check_access = CheckAccess.new([1, 2], [1, 2])
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should set and get user_libs in @check_access" do
    @check_access.set_libs([1, 2, 3])
    libs = @check_access.get_libs
    assert libs.count > 0
  end

  test "should set user_depts in @check_access" do
    @check_access.set_depts([1, 2, 3])
    depts = @check_access.get_depts
    assert depts.count > 0
  end

end
