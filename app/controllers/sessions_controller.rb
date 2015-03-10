class SessionsController < ApplicationController

def new 
  redirect_to home_path if logged_in?
end

def create
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    login_user!(user)
  else
    flash[:danger] = "There is something wrong with your email or password."
    redirect_to sign_in_path
  end
end

def destroy
  session[:user_id] = nil
  flash[:warning] = "You've signed out."
  redirect_to root_path
end

private

def login_user!(user)
  session[:user_id] = user.id 
  flash[:success] = "You've logged in!"
  redirect_to home_path
end

end
