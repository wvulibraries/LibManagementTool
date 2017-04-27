require 'test_helper'

class RssPresenterTest < ActiveSupport::TestCase
  test 'presenter set params' do
    presenter = RssPresenter.new
    today = Date.today.strftime('%m-%d-%Y')
    presenter.parameters = { date_start: today }
    parameters = presenter.parameters
    assert_equal today, parameters[:date_start], 'date_start were not equal'
  end

  test 'presenter get params' do
    presenter = RssPresenter.new
    assert presenter.parameters, 'retrieved params'
  end

  test 'presenter set parameters date_start and get it back' do
    presenter = RssPresenter.new
    presenter.date = date = Date.today.strftime('%m-%d-%Y')
    presenter.parameters = { date_start: date }
    parameters = presenter.parameters
    assert_equal date, parameters[:date_start], 'dates were not equal'
  end

  test 'presenter get valid hours with only start date' do
    presenter = RssPresenter.new(date_start: Date.today.strftime('%m-%d-%Y'))
    presenter.date = Time.now.strftime('%m-%d-%Y')
    presenter.create_day
    assert presenter.rss_array, 'retrieved array'
  end

  test 'presenter create timestamps' do
    presenter = RssPresenter.new(date_start: Date.today.strftime('%m-%d-%Y'))
    presenter.date = Time.now.strftime('%m-%d-%Y')
    time_hash = { open_time: '9:00 AM', close_time: '10:00 PM' }
    timestamps = presenter.make_timestamps(time_hash)
    assert timestamps[:open_time_stamp] > 0, 'retrieved timestamp'
  end
end
