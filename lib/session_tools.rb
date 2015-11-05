module SessionTools


  def logout(user, session)
    session[user.id] = nil
  end

  def current_user(session)
    UserRepository.find session[:user_id]
  end

end