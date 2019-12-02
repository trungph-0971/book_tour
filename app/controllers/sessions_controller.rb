class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      # Log the user in and redirect to the user's show page.
    else
      flash.now[:danger] = t ".login_failed"
      render :new
    end
  end

  def destroy; end
end
