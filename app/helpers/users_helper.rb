module UsersHelper

  def avatar_for(user)
    @avatar_user = user.avatar ? user.avatar : "ruby.png"
  end

end
