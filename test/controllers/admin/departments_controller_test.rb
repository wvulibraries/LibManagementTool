require 'test_helper'

class Admin::DepartmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @department = Department.find(1)
    @library = Library.find(1)
    @department.library_id = @library.id
    @user = User.find(1)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get departments_url
    assert_response :success
  end

  test "should get new" do
    get new_department_url
    assert_response :success
  end

  test "should create department" do
    assert_difference('Department.count') do
      post departments_url, params: { department: { description: @department.description, name: @department.name, library_id: @department.library_id } }
    end

    assert_redirected_to department_url(Department.last)
  end

  test "should show department" do
    get department_url(@department)
    assert_response :success
  end

  test "should get edit" do
    get edit_department_url(@department)
    assert_response :success
  end

  test "should update department" do
    patch department_url(@department), params: { department: { description: @department.description, name: @department.name } }
    assert_redirected_to department_url(@department)
  end

  test "should destroy department" do
    assert_difference('Department.count', -1) do
      delete department_url(@department)
    end

    assert_redirected_to departments_url
  end
end
