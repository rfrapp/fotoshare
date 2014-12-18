class UsersController < ApplicationController
  before_action :logged_in_user, only: [:find, :edit, :update, :destroy, :settings]
  before_action :correct_user, only: [:edit, :update, :settings]
  before_action :admin_user, only: :destroy 
  before_action :blocked_user, only: :show 

  def new
    @user = User.new 
  end 

  def show
    if !params[:id] && !logged_in?
      flash[:danger] = "Please log in to see your profile."
      redirect_to login_path 
    elsif !@user
      @user = current_user 
    end 

    # @user = User.find(params[:id])
    @relationships = @user.relationships + @user.inverse_relationships
    @albums = @user.albums.paginate(page: params[:page])

    redirect_to login_path and return unless @user.activated? 
  end

  def home
    if !params[:id] && !logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_path 
    elsif !@user
      @user = current_user 
    end 

    @feed_items = @user.feed.paginate(page: params[:page])
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update 
    if @user.update_attribute(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user 
    else 
      render 'edit'
    end 
  end 

  def index  
    @users = User.where(activated: true).paginate(page: params[:page])
  end 

  def create
    @user = User.new(user_params)

    if @user.save 
      # log_in @user 
      # flash[:success] = "You have successfully created your account!"
      # redirect_to @user 
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to login_path
    else 
      render "new"
    end
  end 

  def settings 

  end 

  def destroy
    User.find(params[:id]).destroy 
    flash[:success] = "User deleted"
    redirect_to users_url 
  end 

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end 

  # Redirects a user if they are on the Blocked Users
  # list of the person who's profile they're viewing
  def blocked_user
    is_blocked = false 

    if params[:id]
      @user = User.find(params[:id])

      for r in current_user.inverse_relationships
        if r.usergroup.name == "Blocked Users" && r.user.id == @user.id 
          is_blocked = true 
          break 
        end 
      end 
    end

    if is_blocked
      flash[:info] = "This user has chosen to keep their profile hidden."
      redirect_to login_path 
    end 
  end 

  def correct_user
    if params[:id]
      @user = User.find(params[:id])
    else 
      @user = current_user 
    end 
    redirect_to(login_path) unless current_user?(@user)
  end 

  def admin_user
    redirect_to(login_path) unless current_user.admin? 
  end 

end
