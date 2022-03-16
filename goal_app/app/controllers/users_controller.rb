class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      login(@user)
      
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render :index
  end

  def show
    @user = User.find(params[:id])
    if logged_in?
      render :show
    else
      redirect_to new_session_url
    end
  end

  def index
    if logged_in?
      @users = User.all
      render :index
    else
      redirect_to new_session_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end