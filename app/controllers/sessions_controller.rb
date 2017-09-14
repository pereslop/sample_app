class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:sessions][:password])
      #log the user
    else
      #create an error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  def destroy

  end
end
