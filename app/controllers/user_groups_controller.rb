class UserGroupsController < ApplicationController
  before_action :logged_in_user

  # Lists all the members of the 
  # group. If no id param is given,
  # assume to look at current_user's
  # group. URL should look like:
  # root_url/usergroups/friends
  # to see the current_user's friends
  # and 
  # root_url/usergroups/id/friends
  # to see the user with id "id"'s friends
  def index
    id = -1 
    if params[:id] 
        id = params[:id]
    else 
        id = current_user.id 
    end 

    @user  = User.find(id)

  end

  def show
    id = -1 
    if params[:id] 
        id = params[:id]
    else 
        id = current_user.id 
    end 

    @user  = User.find(id)
    @group = UserGroup.find_by(user_id: id, name: params[:group])
    @group_members = @user.relationships.where(user_id: @user.id, 
                                               group_id: @group.id)
    other_relationships = [] 
    other_relationships << @user.inverse_relationships

    # Append relationships for the same group name
    # where the selected user's id is the
    # foreign key 
    for assoc in other_relationships
        for r in assoc 
            if r.usergroup.name == @group.name 
                (@group_members ||= []) << r 
            end 
        end
    end 
  end 

  def new
    @group = UserGroup.new 
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy 
  end 

  private 
    # Confirms a logged-in user.
    def logged_in_user
        unless logged_in?
          store_location 
          flash[:danger] = "Please log in to view this page."
          redirect_to login_url
        end
    end
end
