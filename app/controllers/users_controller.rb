class UsersController < ApplicationController
  before_action :logget_in_user?, only: [:index, :edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def edit
    @user = User.find_by(params[:id])
  end

  def update
    @user = resource
    if @user.update_attributes(user_params)
      flash[:success] = 'profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'user deleted'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end



  def collection
    User.all
  end

  def resource
    collection.find(params[:id])
  end

  def logget_in_user?
    unless logged_in?
      store_location
      flash[:danger] = 'please log in. '
      redirect_to login_url
    end
  end

  def correct_user?
    redirect_to(root_url) unless current_user?(resource)
  end

  def admin_user
    redirect_to(root_url) unless  current_user.admin?
  end
end