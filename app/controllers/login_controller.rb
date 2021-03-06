class LoginController < ApplicationController
  def destroy
    session[:current_user_id] = nil
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email]).try(:authenticate, params[:user][:password])

    if @user && @user.email_confirmed == true
      session[:current_user_id] = @user.id
      redirect_to root_path
    elsif @user && @user.email_confirmed == false
      flash.now[:error] = "Your email address has not been confirmed"
      render :new
    else
      @user = User.new
      flash.now[:error] = "User/Password Combination is not correct"
      render :new
    end
  end
end