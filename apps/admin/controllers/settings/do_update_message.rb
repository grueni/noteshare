module Admin::Controllers::Settings
  class DoUpdateMessage
    include Admin::Action

    def call(params)

      new_message = params['update_settings']['message']
      @settings = SettingsRepository.first
      @settings.set_key('message', new_message)
      SettingsRepository.update @settings

      self.body = 'OK'

    end
  end
end
