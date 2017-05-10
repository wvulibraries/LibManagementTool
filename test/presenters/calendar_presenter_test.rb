require 'test_helper'

class CalendarPresenterTest < ActiveSupport::TestCase
  def setup
    @presenter = CalendarPresenter.new
  end

  test 'presenter resource_name' do
    assert @presenter.resource_name(id: 1, type: 'library'), 'Get resource name'
  end
end
