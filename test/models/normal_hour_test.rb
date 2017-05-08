require 'test_helper'

class NormalHourTest < ActiveSupport::TestCase
  def setup
    @nh1 = normal_hours(:test_hour1)
    @nh2 = normal_hours(:test_hour2)
    @nh3 = normal_hours(:test_hour3)
  end

  test 'normal hour is valid' do
    assert @nh3.valid?, 'there was not a valid normal hour'
  end

  test 'normal hour has a valid id that is an integer or nil' do
    @nh3.id = 'asdfklasjhdff2388205kf'
    assert_not @nh3.save, 'normal hour saved with an invalid id'
  end

  test 'normal hour has blank open_time and close_time' do
    assert_not @nh1.save, 'normal hour saved with blank open_time and close_time'
  end

  test 'weekday must be between 0 and 6 for enumerator to work properly' do
    @nh1.day_of_week = 8
    assert_not @nh1.save, 'normal hour saved with a weekday greater than possible weekday'
  end

  test 'weekday method returns a human readable date' do
    @nh1.day_of_week = 0
    @nh1.save
    assert_equal 'Sunday', @nh1.weekday, 'weekday did not return as expected'
  end

  test 'human readable time comes back correctly for open time' do
    assert_equal '8:00 AM', @nh2.hr_open_time, "hours didn't return as equals and human readable"
  end

  test "human readable time comes back correctly for close time" do
    assert_equal '6:00 PM', @nh2.hr_close_time, "hours didn't return as equals and human readable"
  end

  test 'testing that resource is returning the correct type' do
    assert_equal 'library', @nh1.resource_type, 'returned the wrong resource type'
  end
end
