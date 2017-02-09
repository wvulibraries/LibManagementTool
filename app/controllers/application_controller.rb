class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :warning, :danger, :info, :error

  def clean_array (array_to_clean)
    array_to_clean.reject { |item| item.blank? }
  end
end
