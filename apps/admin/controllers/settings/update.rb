module Admin::Controllers::Settings
  class Update
    include Admin::Action

    expose :settings

    def call(params)

      @settings = SettingsRepository.first

    end
  end
end
