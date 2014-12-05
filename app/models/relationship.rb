class Relationship < ActiveRecord::Base
	belongs_to :user 
	belongs_to :relationship, :class_name => "User", :foreign_key => "other_user_id"
end
