require 'test_helper'
class Admin::SpecialHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.find(1)
    @special_hour = SpecialHour.find(1)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "Admin", :mail => "username1@nowhere.com"})
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get index" do
    get special_hours_url
    assert_response :success
  end

  test "should fail get index" do
    CASClient::Frameworks::Rails::Filter.fake("username")
    get special_hours_url
    assert_redirected_to root_path
  end

  test "should get new" do
    get new_special_hour_url
    assert_response :success
  end

  test "should create special_hour" do
    assert_difference('SpecialHour.count') do
      post special_hours_url, params: {
        special_hour: {
          special_type: 'library',
          special_id: 1,
          close_time: Time.now + 20.days,
          end_date:  Time.now + 22.days,
          name: @special_hour.name,
          no_close_time: @special_hour.no_close_time,
          no_open_time: @special_hour.no_open_time,
          open_24: @special_hour.open_24,
          open_time: @special_hour.open_time,
          start_date: Time.now + 21.days
        }
      }
    end
    assert_redirected_to special_hour_url(SpecialHour.last)
  end

  test "should not create special hour because the start and end date overlap" do
    assert_no_difference('SpecialHour.count') do
      post special_hours_url, params: {
        special_hour: {
          special_type: @special_hour.special_type,
          special_id: @special_hour.special_id,
          close_time: @special_hour.close_time,
          end_date: @special_hour.start_date,
          name: @special_hour.name,
          no_close_time: @special_hour.no_close_time,
          no_open_time: @special_hour.no_open_time,
          open_24: @special_hour.open_24,
          open_time: @special_hour.open_time,
          start_date: @special_hour.end_date
        }
      }
    end
    assert_redirected_to special_hours_url, 'test allowed the creation of an hour with overlapping dates'
  end

  test "should not create special_hour, start date overlaps" do
    assert_no_difference('SpecialHour.count') do
      post special_hours_url, params: {
        special_hour: {
          special_type: @special_hour.special_type,
          special_id: @special_hour.special_id,
          close_time: @special_hour.close_time,
          end_date: @special_hour.end_date,
          name: @special_hour.name,
          no_close_time: @special_hour.no_close_time,
          no_open_time: @special_hour.no_open_time,
          open_24: @special_hour.open_24,
          open_time: @special_hour.open_time,
          start_date: @special_hour.start_date + 1.day
        }
      }
    end
    assert_redirected_to special_hours_url, 'test allowed the creation of an hour with overlapping dates'
  end

  test "should not create special_hour end_date before start_date" do
    assert_no_difference('SpecialHour.count') do
      post special_hours_url, params: {
        special_hour: {
          special_type: 'library',
          special_id: 1,
          close_time: @special_hour.close_time,
          end_date: @special_hour.start_date,
          name: @special_hour.name,
          no_close_time: @special_hour.no_close_time,
          no_open_time: @special_hour.no_open_time,
          open_24: @special_hour.open_24,
          open_time: @special_hour.open_time,
          start_date: @special_hour.end_date
        }
      }
    end
  end

  test "should not create special_hour user has no access to resource" do
    # set user that doesn't have access
    @user = User.find(10)
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "not_admin", :mail => "username10@nowhere.com"})
    assert_no_difference('SpecialHour.count') do
      post special_hours_url, params: {
        special_hour: {
          special_type: @special_hour.special_type,
          special_id: 3,
          close_time: @special_hour.close_time,
          end_date: @special_hour.start_date,
          name: @special_hour.name,
          no_close_time: @special_hour.no_close_time,
          no_open_time: @special_hour.no_open_time,
          open_24: @special_hour.open_24,
          open_time: @special_hour.open_time,
          start_date: @special_hour.end_date
        }
      }
    end
  end

  test "should show special_hour" do
    get special_hour_url(@special_hour)
    assert_response :success
  end

  test "should get edit" do
    get edit_special_hour_url(@special_hour)
    assert_response :success
  end

  test "should update special_hour" do
    new_start_date = (@special_hour.start_date + 1.day).beginning_of_day
    patch special_hour_url(@special_hour), params: { special_hour: { id: @special_hour.id, start_date: new_start_date}}
    assert_redirected_to special_hours_url, 'did not redirect properly from the patch'
  end

  test "should not update special_hour" do
    # set user that doesn't have admin access
    @user = User.find(10)
    # puts user.username.inspect
    CASClient::Frameworks::Rails::Filter.fake(@user.username, {:sn => "not_admin", :mail => "username10@nowhere.com"})

    # increase start_date by 1 day
    patch special_hour_url(@special_hour), params: { special_hour: { special_id: 3 }}
    @special_hour.reload
    assert 3 != @special_hour.special_id
  end

  test "should destroy special_hour" do
    assert_difference('SpecialHour.count', -1) do
      delete special_hour_url(@special_hour)
    end

    assert_redirected_to special_hours_url
  end

  test 'the special hour date ranges do not overlap ones currently in the database' do
    check_start = SpecialHour.where.not(id: @special_hour.id).where('special_id = ?', @special_hour.special_id).where('special_type = ?', @special_hour.special_type).where('start_date <= ?', @special_hour.start_date).where('end_date >= ?', @special_hour.start_date).exists?

    check_end = SpecialHour.where.not(id: @special_hour.id).where('special_id = ?', @special_hour.special_id).where('special_type = ?', @special_hour.special_type).where('start_date <= ?', @special_hour.end_date).where('end_date >= ?', @special_hour.end_date).exists?

    assert_not check_start, "start returned true, but it sould have been false"
    assert_not check_end, "end returned true, but it sould have been false"

    check_start = SpecialHour.where.not(id: 7).where('special_id = ?', @special_hour.special_id).where('special_type = ?', @special_hour.special_type).where('start_date <= ?', @special_hour.start_date).where('end_date >= ?', @special_hour.start_date).exists?

    check_end = SpecialHour.where.not(id: 7).where('special_id = ?', @special_hour.special_id).where('special_type = ?', @special_hour.special_type).where('start_date <= ?', @special_hour.end_date).where('end_date >= ?', @special_hour.end_date).exists?

    assert check_start, "start returned false, but it sould have been true"
    assert check_end, "end returned false, but it sould have been true"

    check_start = SpecialHour.where.not(id: 7).where('special_id = ?', @special_hour.special_id).where('special_type = ?', @special_hour.special_type).where('start_date <= ?', (@special_hour.end_date + 21.days)).where('end_date >= ?', (@special_hour.end_date + 21.days)).exists?

    check_end = SpecialHour.where.not(id: 7).where('special_id = ?', @special_hour.special_id).where('special_type = ?', @special_hour.special_type).where('start_date <= ?', (@special_hour.end_date + 25.days)).where('end_date >= ?', (@special_hour.end_date + 25.days)).exists?

    assert_not check_start, "start returned true, but it sould have been false"
    assert_not check_end, "end returned true, but it sould have been false"
  end
end
