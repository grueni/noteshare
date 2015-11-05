class User
  include Lotus::Entity
  attributes :id, :first_name, :last_name, :email, :screen_name, :level, :password, :password_confirmation

  # http://hawkins.io/2012/07/rack_from_the_beginning/
  # https://blog.engineyard.com/2015/understanding-rack-apps-and-middleware
  # session = Rack::Session::Cookie.new(self, {
  #    :coder => Rack::Session::Cookie::Identity.new
  #})



  def set_password(new_password)
    self.password = BCrypt::Password.create(new_password)
    UserRepository.update self
    return true
  end

  def authenticate(password)
    BCrypt::Password.new(self.password) == password
  end

  def login(password)
    if self.authenticate(password)
      # session[:user_id] = self.id
      return true
    else
      return false
    end
  end

  def logout
    session[self.id] = nil
  end

  def self.current_user
    UserRepository.find session[:user_id]
  end


end
