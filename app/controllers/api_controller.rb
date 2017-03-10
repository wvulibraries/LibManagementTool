class ApiController < ApplicationController
  def gethours
    ##@hours = NormalHours.ads_shown.sorted_priority
  end

  def getlibs
    @libraries = Library.all
  end

end
