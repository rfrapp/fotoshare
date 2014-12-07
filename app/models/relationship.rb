class Relationship < ActiveRecord::Base
	belongs_to :user 
	belongs_to :relationship, :class_name => "User", :foreign_key => "other_user_id"
	belongs_to :usergroup, :class_name => "UserGroup", :foreign_key => "group_id"

end
