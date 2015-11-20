# https://github.com/rails/jquery-ujs/blob/master/src/rails.js#L59
# Take a look at Warden (mentioned by @solnic):
#
#  https://github.com/hassox/warden/wiki
#
# Info on Rack-based-apps:
#
# https://www.mobomo.com/2010/4/rack-middleware-and-applications-whats-the-difference/


 # https://github.com/lotus/lotus/blob/master/lib/lotus/action/csrf_protection.rb#L65

class UserAuthentication

  def initialize(email, password)
    @email = email
    @password = password
    @user = UserRepository.find_one_by_email(@email)
  end

  def authenticate
    BCrypt::Password.new(@user.password) == @password if @user
  end

  def login(session)
    if authenticate
      session[:user_id] = @user.id
      session[:current_document_id] = @user.recall_current_document_id(session)
      session[:current_image_id] = nil
      return @user
    end
  end

end


module SessionTools

  def logout(user, session)
    puts "LOGOUT".red
    user.remember_current_document_id(session)
    UserRepository.update user
    session[:current_document_id] = nil
    session[:current_image_id] = nil
    session[:user_id] = nil
  end

  def current_user(session)
    UserRepository.find session[:user_id]
  end

  def current_user_is_admin?(session)
    user = UserRepository.find session[:user_id]
    return false if user == nil
    return user.admin
  end

end