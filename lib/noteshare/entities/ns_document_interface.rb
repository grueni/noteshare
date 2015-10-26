# Interface to other classes

module NSDocument::Interface


  def current_user_full_name
    # SettingsRepository.first.owner
    user = UsersRepository.first
    "#{user.first_name} #{user.last_name}"
  end

  class User

    def self.current
      SettingsRepository.first.owner
    end

  end



end