class ApiController < ApplicationController
  def getlibs
    @libraries = Library.all
  end

  def getdepts
    @departments = Department.all
  end

  def gethours
    ##@hours = NormalHours.ads_shown.sorted_priority
  end

end
