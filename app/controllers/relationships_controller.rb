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

	def destroy
		@relationship = Relationship.find(params[:id])
		@relationship.destroy 
		flash[:success] = "Removed Relationship."
		redirect_to root_url 
	end

end
