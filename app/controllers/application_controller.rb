class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception

  def hello
    render html: t("views.layouts.hello")
  end

  def respond_modal_with *args, &blk
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with(*args, options, &blk)
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".please_login"
    redirect_to login_path
  end
end
