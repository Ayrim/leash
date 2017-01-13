class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  $title = "leash"

  before_action :set_locale
  def set_locale
  	if(params[:locale])
  		session[:locale] = params[:locale]
  	end
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale

  end
end
