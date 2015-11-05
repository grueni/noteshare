
class UserAuthentication

  attr :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  def authenticate
    user = UserRepository.find_one_by_email(@email)
    BCrypt::Password.new(user.password) == password if user
  end

  def login(session)
    if self.authenticate
      session[:user_id] = self.id
      return true
    else
      return false
    end
  end

=begin
  def logout
    session[self.id] = nil
  end

  def self.current_user
    UserRepository.find session[:user_id]
  end
=end

end