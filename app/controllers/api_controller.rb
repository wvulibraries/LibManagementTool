class ApiController < ApplicationController
  def libs
    @libraries = Library.all
  end

  def depts
    @departments = Department.all
  end

  def deptsbylib
    @departments = Department.lib_sorted
  end

  def hours
    @presenter = ApiPresenter.new(params)
    @presenter.generate_list
    @hours = @presenter.api_array
  end
end
