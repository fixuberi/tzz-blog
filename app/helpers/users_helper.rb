module UsersHelper

  def avatar_for(user)
    @avatar = user.avatar
    if @avatar.attached?
      @avatar_user = @avatar
    else
      @avatar_user = "ruby.png"
    end
    return @avatar_user
  end

end
