require 'test_helper'

class HoursPresenterTest < ActiveSupport::TestCase
  def setup
    @presenter = HoursPresenter.new
  end

  test 'get departments' do
    assert @presenter.departments, 'Returns available departments'
  end

  test 'get libraries' do
    assert @presenter.libraries, 'Returns available libraries'
  end

  test 'get resource list' do
    assert @presenter.resources_for_list, 'Returns available resources'
  end
end
