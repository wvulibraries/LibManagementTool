require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should have the necessary required validators" do
    user = User.new
    assert_not user.valid?
    # assert_equal [:username, :firstname, :lastname], post.errors.keys
  end

  test "user is valid" do
    user = User.new(username:'user1', firstname: 'frank', lastname:'boyd', admin: false)
    assert user.valid?
  end

  test "user can't be saved without a username" do
    user = User.new(username:nil, firstname: 'frank', lastname:'boyd', admin: false)
    assert_not user.valid?
  end

  test "user can't be saved without firstname" do
    user = User.new(username:'user1', firstname:nil, lastname:'boyd', admin: false)
    assert_not user.valid?
  end

  test "user can't be saved without lastname" do
    user = User.new(username:'user1', firstname:'frank', lastname:nil, admin: false)
    assert_not user.valid?
  end

  test "user admin key is not allowed to be null" do
    user = User.new(username:'user1', firstname: 'frank', lastname:'boyd', admin:nil)
    assert_not user.valid?
  end
end
