class RelationshipsController < ApplicationController

	def create

		# Add the relationship for the user
		# who requested it
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

			# Adds the group to the other user's groups
			# if they don't have the group already 
			check_other_user_groups(@relationship.other_user_id, @relationship.group_id)
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
		@relationship ||= current_user.pending_relationships.find(params[:id])
		@relationship ||= current_user.inverse_relationships.find(params[:id])
		@relationship ||= current_user.inverse_pending_relationships.find(params[:id])

		@relationship.destroy 
		flash[:success] = "Removed Relationship."
		redirect_to current_user 
	end

	private
		def check_other_user_groups(other_user_id, group_id)
			other_user = User.find(other_user_id)
			group  = UserGroup.find(group_id)
			groups = [] 
			groups << other_user.user_groups.find_by(name: group.name)

			if groups.nil? || groups.length == 0
				UserGroup.insert_new(other_user, group.name)
			end 
		end 

end
