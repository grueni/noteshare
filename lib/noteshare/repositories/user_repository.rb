require 'bcrypt'

class UserRepository
  include Lotus::Repository

  def self.find_by_email(email)
    query do
      where(email: email)
    end
  end

  def self.find_one_by_email(email)
    result = self.find_by_email(email)
    return result.first if result
  end

  def self.authenticate(email, password)
    user = self.find_one_by_email(email)
    return false if user.nil?
    BCrypt::Password.new(user.password) == password
  end

  def self.set_password(email, password)
    user = self.find_one_by_email(email)
    return false if user.nil?
    user.password = BCrypt::Password.create(password)
    UserRepository.update user
    return true
  end

end
