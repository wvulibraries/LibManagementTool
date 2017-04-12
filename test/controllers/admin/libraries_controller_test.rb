require 'test_helper'

class Admin::LibrariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @library = Library.find(1)
    @user = User.find(1)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get libraries_url
    assert_response :success
  end

  test "should get new" do
    get new_library_url
    assert_response :success
  end

  test "should create library" do
    assert_difference('Library.count') do
      post libraries_url, params: { library: { description: @library.description, name: @library.name } }
    end

    assert_redirected_to library_url(Library.last)
  end

  test "should not create library for user without admin access" do
    # set user that doesn't have admin access
    @user = User.find(10)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "not_admin", :mail => "username10@nowhere.com"})
    assert_no_difference('Library.count') do
      post libraries_url, params: { library: { description: @library.description, name: @library.name } }
    end
  end

  test "should show library" do
    get libraries_url, params: { id: @library.id }
    assert_response :success
  end

  test "should get edit" do
    get edit_library_url(@library)
    assert_response :success
  end

  test "should update library" do
    patch library_url(@library), params: { library: { description: @library.description, name: @library.name } }
    assert_redirected_to library_url(@library)
  end

  test "should destroy library" do
    assert_difference('Library.count', -1) do
      delete library_url(@library)
    end

    assert_redirected_to libraries_url
  end
end
