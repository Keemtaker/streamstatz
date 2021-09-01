class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  around_action :switch_locale
  before_action :set_locale

  private

  def switch_locale(&action)
    locale = params[:locale] || session[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def set_locale
    session[:locale] = I18n.locale
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
end
