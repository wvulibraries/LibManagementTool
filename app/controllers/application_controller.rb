class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :warning, :danger, :info, :error

  def clean_array (array_to_clean)
    if !array_to_clean.empty?
     array_to_clean.reject { |item| item.blank? }
    else
     []
    end
  end
end
