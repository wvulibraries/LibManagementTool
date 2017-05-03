class Public::HoursController < ApplicationController

  def index
    # check if id and type are passed if not set them
    # to the first library
    if !params[:id].present? && !params[:type].present?
      params[:id] = 1
      params[:type] = 'library'
    end

    @presenter = CalendarPresenter.new
    @libraries = Library.all
  end

end
