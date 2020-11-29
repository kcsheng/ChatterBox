class UsersController < ApplicationController
  before_action :check_login, only: [:index, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update]
  before_action :check_admin, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to ChatterBox!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted!'
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def check_login
      unless logged_in?
        store_url
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end

    def check_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) 
    end

    def check_admin
      redirect_to(root_url) unless current_user.admin?
    end
end
