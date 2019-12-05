class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper

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
end
