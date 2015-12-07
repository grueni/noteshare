module Admin::Controllers::Settings
  class Update
    include Admin::Action

    expose :settings, :active_item

    def call(params)
      @active_item = 'admin'
      @settings = SettingsRepository.first
    end
  end
end
