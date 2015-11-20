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
      puts "in login, authenticate  is successful".magenta
      puts "  -- user id is #{@user.id}".green
      # puts "  -- session is #{session.inspect}".blue  if ENV[LOG_THIS]
      session[:user_id] = @user.id
      return @user
    end
  end

end


module SessionTools

  def logout(user, session)
    session[user.id] = nil
  end

  def current_user(session)
    UserRepository.find session[:user_id]
  end

end