require 'test_helper'

class LibraryTest < ActiveSupport::TestCase
  def setup
    @library = Library.new(name: "Downtown Campus Library", description: "Main Lib", id: 1)
  end

  test "library is valid" do
    assert @library.valid?, "library was not valid"
  end

  test "should not save a library without a name" do
    @library.name = nil
    assert_not @library.save, "Library saved without a name"
  end

  test "library should save given a name, but nothing else" do
    @library.description = nil
    @library.id = nil
    assert @library.save, "Library failed to save, something has gone wrong"
  end

  test "library id for new library" do
    @library.id = 100
    assert_equal 100, @library.id,  "Library doesn't have the correct id"
  end

  test "library that the id only saves as an integer" do
    @library.id = "salk2389t5yaslkjfr"
    assert_not @library.save, "Library saved with wrong format for id"
  end

  test "description of library is under 500 characters" do
    @library.description = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus."
    assert_not @library.save, "Library failed to save with too long of a description"
  end

  test "Library has department" do
    assert_not_nil @library.departments, "Library didn't have a department, but it should have had one"
  end
end
