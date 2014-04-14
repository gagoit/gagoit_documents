module UsersHelper
	def avatar_url(user)
		(user && user.avatar) ? user.avatar.url : 'no-avatar.jpg'
	end
end
