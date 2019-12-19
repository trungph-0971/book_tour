class PasswordResetsController < ApplicationController
  before_action :load_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".sent"
      redirect_to root_path
    else
      flash.now[:danger] = t ".notfound"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    return if @user = User.find_by(email: params[:email])

    flash.now[:danger] = t "password_resets.create.notfound"
    render :new
  end

  # Confirms a valid user.
  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("password_resets.update.expired")
    redirect_to new_password_reset_url
  end
end
