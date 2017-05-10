# FeedsController
# @author Tracy A. McCormick

class FeedsController < ApplicationController
  layout false

  def index
    @presenter = RssPresenter.new
    @presenter.parameters = params
    @presenter.date = params[:date] || Time.now.strftime('%m-%d-%Y')

    @presenter.create_day
    @resources = @presenter.rss_array
  end
end
