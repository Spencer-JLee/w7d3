class SessionsController < ApplicationController

  before_action :require_logged_in, only: [:destroy]
  before_action :require_logged_out, only: [:create, :new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(params[:user][:username], params[:user][:password])
    if @user.save
      login(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    logout!
    render :new
  end

end
