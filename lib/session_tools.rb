module SessionTools


  def self.logout(user)
    session[user.id] = nil
  end

  def self.current_user
    UserRepository.find session[:user_id]
  end

end