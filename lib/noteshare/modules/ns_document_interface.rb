  # Interface to other classes

module NSDocument::Interface


  def current_user_full_name
    # SettingsRepository.first.owner
    user = UserRepository.first
    "#{user.first_name} #{user.last_name}"
  end

  class UserXX

    def self.current
      SettingsRepository.first.owner
    end

  end



end