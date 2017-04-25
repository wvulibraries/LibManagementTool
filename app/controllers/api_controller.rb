class ApiController < ApplicationController
  def getlibs
    @libraries = Library.all
  end

  def getdepts
    @departments = Department.all
  end

  def getdeptsbylib
    @departments = Department.lib_sorted
  end

  def gethours
    @presenter = ApiPresenter.new(params)
    @presenter.generate_list
    @hours = @presenter.api_array
  end
end
