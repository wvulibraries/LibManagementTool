# FeedsController
# @author Tracy A. McCormick

class FeedsController < ApplicationController
  layout false

  def index
    @presenter = RssPresenter.new
    @presenter.p = params
    @presenter.date = params[:date] || Time.now.strftime('%m-%d-%Y')

    @presenter.generate_list
    @resources = @presenter.rss_array
  end
end
