require 'test_helper'

class ApiPresenterTest < ActiveSupport::TestCase
  def setup
    @presenter = ApiPresenter.new({})
  end

  test "presenter get valid hours" do
    assert @presenter.get_hours, "retrieved hours"
  end

  test "presenter get valid hours with start date" do
    date = Date.today.strftime('%m-%d-%Y')
    @presenter.set_params({date_start: date})
    params = @presenter.get_params
    assert_equal date, params[:date_start], "dates were not equal"
  end

  test "should return same start and end dates" do
    today = Date.today.strftime('%m-%d-%Y')
    tomorrow = Date.tomorrow.strftime('%m-%d-%Y')
    @presenter.set_params({date_start: today, date_end: tomorrow})
    params = @presenter.get_params
    assert_equal today, params[:date_start], "date_start were not equal"
    assert_equal tomorrow, params[:date_end], "date_end were not equal"
  end

  test "presenter get valid hours with only start date" do
    @presenter.set_params({date_start: Date.today.strftime('%m-%d-%Y') })
    assert @presenter.get_hours, "retrieved hours"
  end

  test "presenter get valid hours with both start date and end date" do
    @presenter.set_params({date_start: Date.today.strftime('%m-%d-%Y'), date_end: Date.tomorrow.strftime('%m-%d-%Y') })
    assert @presenter.get_hours, "retrieved hours"
  end

  test "presenter get params" do
    assert @presenter.get_params, "retrieved params"
  end

  test "presenter format_date" do
    assert @presenter.format_date('04-01-2017'), "converted date string to date object"
  end

  test "presenter array_push" do
    assert @presenter.array_push({name: 'test', date: Date.today.strftime('%m-%d-%Y'), open_time: '', close_time: '', comment: 'test comment'}), "Pushed new item to the presenter array"
  end

  test "presenter get_resource_name" do
    assert @presenter.get_resource_name({id: 1, type: 'library'}), "Get resource name"
  end

  test "presenter get_day_list" do
    assert @presenter.get_day_list, "Sets hours_array based on collection of resources"
  end

  test "returns hash of values for requested resource and date" do
    assert @presenter.get_date({id: 1, type: 'library', date: Date.today.strftime('%Y-%m-%d')}), "get_date returned date for resource"
  end

  test "returns hash of values for requested resource and day" do
    assert @presenter.get_day(Date.today, {id: 1, type: 'library'}), "get_date returned date for resource"
  end
end
