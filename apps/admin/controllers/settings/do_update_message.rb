module Admin::Controllers::Settings
  class DoUpdateMessage
    include Admin::Action

    expose :active_item

    def call(params)
      @active_item = 'admin'
      new_message = params['update_settings']['message']
      @settings = SettingsRepository.first
      @settings.set_key('message', new_message)
      SettingsRepository.update @settings

      #  self.body = 'OK'
      redirect_to "/node/user/#{current_user(session).id}"

    end
  end
end
