class SessionsController < ApplicationController
  before_action :not_logged_in, only: [:create, :new]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if @user.nil?
      render json: "Credentials were wrong"
    else
      login!(@user)
      redirect_to cats_url
    end

  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end


  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end

  def not_logged_in
    unless current_user.nil?
      redirect_to cats_url
    end
  end
end
