class UsersController < ApplicationController
  before_filter :authenticate,    :only => [:index, :edit, :update, :destroy]
  before_filter :authenticate,    :except => [:show, :new, :create]

  before_filter :correct_user,    :only => [:edit, :update]
  before_filter :admin_user,      :only => :destroy
  before_filter :signed_in_user,  :only => [:new, :create]
  before_filter :admin_destroy,   :only => :destroy

  def new
    @user = User.new
    @title = "Sign up"  
  end

  def create 
    @user = User.new(params[:user])
    if @user.save
      #handle a successful save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page =>  params[:page])
    @title = @user.name
  end
  
  def edit
    @title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def admin_destroy
      if User.find(params[:id]) == current_user
         flash[:error] = "You cannot delete yourself."
         redirect_to(users_path)
      end
    end

    def signed_in_user
      if signed_in?
        flash[:info] = "You're already logged in..."
        redirect_to(users_path)
      end
    end
end
