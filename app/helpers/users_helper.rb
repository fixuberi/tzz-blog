module UsersHelper

  def avatar_for(user)
    @avatar_user = user.avatar.attached? ? user.avatar : "ruby.png"
  end

end
