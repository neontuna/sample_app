class UsersController < ApplicationController
  before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :admin_user,      only: :destroy

  def show
  	@user = User.find(params[:id])
  end

  def new
    if signed_in?
        redirect_to(root_url)
        flash[:notice] = "You already have an account!"
    else 
  	   @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    if signed_in?
      redirect_to(root_url)
      flash[:error] = "You already have an account!"
    elsif @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    # Just rendering the page, currently.
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    if User.find(params[:id]) == current_user
      flash[:error] = "Why are you trying to delete yourself?"
      redirect_to users_url
    elsif    
      User.find(params[:id]).destroy
      flash[:success]= "User destroyed."
      redirect_to users_url
    end
  end



  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." 
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
