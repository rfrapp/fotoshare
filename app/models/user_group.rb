class UserGroup < ActiveRecord::Base
	belongs_to :user 

	def self.insert_new(user, name)
		group = UserGroup.new(user_id: user.id, name: name)
		group.save 
	end
end
