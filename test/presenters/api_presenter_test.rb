require 'test_helper'

class ApiPresenterTest < ActiveSupport::TestCase
  test 'presenter set params' do
    presenter = ApiPresenter.new
    today = Date.today.strftime('%m-%d-%Y')
    presenter.parameters = { date_start: today }
    parameters = presenter.parameters
    assert_equal today, parameters[:date_start], 'date_start were not equal'
  end

  test 'presenter get params' do
    presenter = ApiPresenter.new
    assert presenter.parameters, 'retrieved params'
  end

  test 'presenter get hours for a date range' do
    presenter = ApiPresenter.new
    date_start = Date.today.strftime('%m-%d-%Y')
    date_end = Date.tomorrow.strftime('%m-%d-%Y')
    presenter.parameters = { date_start: date_start, date_end: date_end }
    presenter.generate_list
    assert presenter.api_array, 'retrieved hours'
  end

  test 'presenter get valid hours with start date' do
    presenter = ApiPresenter.new
    date = Date.today.strftime('%m-%d-%Y')
    presenter.parameters = { date_start: date }
    params = presenter.parameters
    assert_equal date, params[:date_start], 'dates were not equal'
  end

  test 'should return same start and end dates' do
    presenter = ApiPresenter.new
    today = Date.today.strftime('%m-%d-%Y')
    tomorrow = Date.tomorrow.strftime('%m-%d-%Y')
    presenter.parameters = { date_start: today, date_end: tomorrow }
    assert_equal today, presenter.parameters[:date_start], 'date_start were not equal'
    assert_equal tomorrow, presenter.parameters[:date_end], 'date_end were not equal'
  end

  test 'presenter get valid hours with only start date' do
    presenter = ApiPresenter.new
    presenter.parameters = { date_start: Date.today.strftime('%m-%d-%Y') }
    presenter.generate_list
    assert presenter.api_array, 'retrieved hour'
  end

  test 'presenter get valid hours with both start date and end date' do
    presenter = ApiPresenter.new
    date_start = Date.today.strftime('%m-%d-%Y')
    date_end = Date.tomorrow.strftime('%m-%d-%Y')
    presenter.parameters = { date_start: date_start, date_end: date_end }
    presenter.generate_list
    assert presenter.api_array, 'retrieved hours'
  end

  # test "presenter array_push" do
  #   assert @presenter.array_push({name: 'test', date: Date.today.strftime('%m-%d-%Y'), open_time: '', close_time: '', comment: 'test comment'}), "Pushed new item to the presenter array"
  # end

  # test "presenter get_resource_name" do
  #   assert @presenter.get_resource_name({id: 1, type: 'library'}), "Get resource name"
  # end

  # test "presenter get_day_list" do
  #   assert @presenter.get_day_list, "Sets hours_array based on collection of resources"
  # end

  # test "returns hash of values for requested resource and date" do
  #   assert @presenter.get_date({id: 1, type: 'library', date: Date.today.strftime('%Y-%m-%d')}), "get_date returned date for resource"
  # end

  # test "returns hash of values for requested resource and day" do
  #   assert @presenter.get_day(Date.today, {id: 1, type: 'library'}), "get_date returned date for resource"
  # end
end
