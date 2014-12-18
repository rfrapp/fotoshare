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
    @group = UserGroup.find_by(user_id: id, name: params[:group])

    if !@group.nil?
        @group_members = get_members(@user, @group)
    end 

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
    # foreign key.
    # NOTE: 
    # The first loop loops through ActiveRecord 
    # Association objects
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
    @group = UserGroup.new(group_params)
    
    if @group.user_id != current_user.id 
        flash[:danger] = "There was an error creating your group."
        render "new"
    end 

    if @group.save 
        flash[:success] = "Successfully created the group: " + @group.name + "!"
        redirect_to home_path 
    else 
        render "new"
    end 

  end

  def edit
    
    if params[:id].to_i != current_user.id
        redirect_to home_path 
    end 

    @group = UserGroup.find_by(user_id: params[:id],
                               name: params[:group])

    if @group.nil?
        redirect_to home_path 
    end 

    @group_members = get_members(current_user, @group)

  end

  def update
  end

  def destroy 
  end 

  private 

    def get_members(user, group)
        group_members = user.relationships.where(user_id: user.id, 
                                                   group_id: group.id)
        other_relationships = [] 
        other_relationships << user.inverse_relationships

        # Append relationships for the same group name
        # where the selected user's id is the
        # foreign key.
        # NOTE: 
        # The first loop loops through ActiveRecord 
        # Association objects
        for assoc in other_relationships
            for r in assoc 
                if r.usergroup.name == group.name 
                    (group_members ||= []) << r 
                end 
            end
        end

        return group_members 
    end 

    def group_params 
        params.require(:user_group).permit(:name, :user_id)
    end 

end
