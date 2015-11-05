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


end
