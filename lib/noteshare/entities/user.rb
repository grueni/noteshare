class User
  include Lotus::Entity
  attributes :id, :first_name, :last_name, :email, :screen_name, :level, :password, :password_confirmation

  def self.authenticate(email, password)
    user = UserRepository.find_one_by_email(email)
    return false if user.nil?
    BCrypt::Password.new(user.password) == password
  end

  def self.set_password(email, password)
    user = UserRepository.find_one_by_email(email)
    return false if user.nil?
    user.password = BCrypt::Password.create(password)
    UserRepository.update user
    return true
  end

end
