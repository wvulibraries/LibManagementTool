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

    ## default response if no params listed
    #@normal_hours = NormalHour.all
  end

end
