class RelationshipsController < ApplicationController

	def create
		@relationship = current_user.relationships.build(:other_user_id => params[:other_user_id], :group_id => params[:group_id])
		@relationship.status = "pending" 

		if @relationship.save 
			flash[:success] = "Request for relationship sent."
			redirect_to root_url 
		else 
			puts "\n\nI am here\n\n"
			flash[:danger]  = "Error adding Relationship."
			redirect_to find_path 
		end
	end	

	def update 
		@relationship = Relationship.find(params[:id])
		@relationship.update_attribute(:status, params[:status])

		message = ""

		if params[:status] == "accept"
			message += "Accepted "
		else 
			message += "Ignored "
		end

		message += @relationship.user.firstname + " "
		message += @relationship.user.lastname 
		message += "'s request to add you to their group \""
		message += @relationship.usergroup.name + '"'
		flash[:success] = message 
		redirect_to current_user 
	end 

	def destroy
		@relationship = current_user.relationships.find(params[:id])
		@relationship.destroy 
		flash[:success] = "Removed Relationship."
		redirect_to current_user 
	end

end
