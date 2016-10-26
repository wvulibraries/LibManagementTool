require 'test_helper'

class SpecialHourTest < ActiveSupport::TestCase
  def setup
    @spec_hour = special_hours(:special_hour1)
    @spec_hour2 = special_hours(:special_hour2)
  end

  test "special hours are valid" do
    assert @spec_hour.valid?, "the special hour is not valid"
  end

  test "special hour id is a valid integer or is a nil" do
    @spec_hour.id = "asdkhjflasdkf2"
    assert_not @spec_hour.save, "this should not save because this isn't a valid integer"
  end

  test "human readable date is coming from the hr_start_date" do
    readable_date = @spec_hour.start_date.strftime("%B %d, %Y").to_s
    assert_equal readable_date, @spec_hour.hr_start_date,  "the date didn't match, the comparison of time must not be correct"
  end

  test "human readable time" do
    readable_time = @spec_hour2.open_time.strftime("%l:%M %p")
    assert_equal readable_time, @spec_hour2.hr_open_time, "the time didn't match, the comparison of human readable time to database time must not be correct"
  end

  test "human readable time for a nil object should return as an empty string" do
    assert_empty @spec_hour.hr_open_time,  "error with the human readable time, it should have come back to with an empty string"
  end

  test "open time should return null for this item and be allowed to save" do
    @spec_hour.open_time = nil
    assert_nil @spec_hour.open_time, "this should have been a nil item, please check to make sure it is set to nil"
    assert @spec_hour.save, "the item didn't save there is a problem with the open time saving to the model"
  end
end
