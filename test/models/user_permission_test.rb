require 'test_helper'

class UserPermissionTest < ActiveSupport::TestCase

  test "permission should have the necessary required validators" do
    permission = UserPermission.new
    assert_not permission.valid?
    #assert_equal [:username], post.errors.keys
  end

  test "user permission is valid" do
    user = UserPermission.new(username:'user1', libraries: ['1','2','3'], departments: ['1'])
    assert user.valid?
  end

  test "user permissions saves only with a valid username" do
    user = UserPermission.new(username:nil, libraries: ['1','2','3'], departments: ['1'])
    assert_not user.valid?
  end

  test "getting an array back out of the database" do
    user = UserPermission.new(username:'user1', libraries: ['1','2','3'], departments: ['1'])
    user.save

    new_user = UserPermission.last
    test_array = []
    assert_equal new_user.departments.class, test_array.class, "arrays are not the same type"
  end
end
