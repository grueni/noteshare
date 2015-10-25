# Interface to other classes

module NSDocument::Interface

  class User

    def self.current
      SettingsRepository.first.owner
    end

  end



end