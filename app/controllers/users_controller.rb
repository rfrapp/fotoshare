class UsersController < ApplicationController

	def new
		@user = User.new 
	end 

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	def find 
		@users = User.all 
	end 

	def create
		@user = User.new(user_params)

		if @user.save 
			log_in @user 
			flash[:success] = "You have successfully created your account!"
			redirect_to @user 
		else 
			render "new"
		end
	end 

private
	def user_params
		params.require(:user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
	end 

end
