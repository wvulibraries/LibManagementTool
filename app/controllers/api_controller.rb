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
    @hours = HoursPresenter.new(params).get_hours
  end

end
