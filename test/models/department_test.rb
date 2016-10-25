require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  def setup
    @department = Department.new(name: "Test", description: "test 2", library_id: 1 )
  end

  test "department is valid" do
    assert @department.valid?, "department was not valid"
  end

  test "should not save a department without a name" do
    @department.name = nil
    assert_not @department.save, "department saved without a name"
  end

  test "department should save given a name, but nothing else" do
    @department.description = nil
    @department.id = nil
    assert @department.save, "department failed to save, something has gone wrong"
  end

  test "department id for new department" do
    @department.id = 100
    assert_equal 100, @department.id,  "department doesn't have the correct id"
  end

  test "should not save a department with a null library id" do
    @department.library_id = nil
    assert_not @department.save, "department saved with a null library id"
  end

  test "department that the id only saves as an integer" do
    @department.id = "salk2389t5yaslkjfr"
    assert_not @department.save, "department saved with wrong format for id"
  end

  test "description of department is under 500 characters" do
    @department.description = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus."
    assert_not @department.save, "department failed to save with too long of a description"
  end

end
