# Interface to other classes

module NSDocument::Interface


  def current_user_name
    SettingsRepository.first.owner
  end

  class User

    def self.current
      SettingsRepository.first.owner
    end

  end



end