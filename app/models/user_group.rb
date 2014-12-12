class UserGroup < ActiveRecord::Base
	belongs_to :user 

	validates :name, presence: true, length: { minimum: 2 }
	validates_uniqueness_of :name, scope: :user_id 

	def self.insert_new(user, name)
		group = UserGroup.new(user_id: user.id, name: name)
		group.save 
	end
end
