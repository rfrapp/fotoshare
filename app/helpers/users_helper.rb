module UsersHelper
	def get_user(id)
		return User.find_by(id: id)
	end
end
