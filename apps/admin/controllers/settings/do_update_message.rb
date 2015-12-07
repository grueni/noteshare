module Admin::Controllers::Settings
  class DoUpdateMessage
    include Admin::Action

    def call(params)

      puts "controller Admin::Controllers::Settings, DoUpdateMessage".red

      new_message = params['update_settings']['message']
      rendererd_messageo = Asciidoctor.convert new_message
      puts "NEW MESSAGE: #{rendererd_messageo}".red

      @settings = SettingsRepository.first
      @settings.set_key('message', rendererd_messageo)
      SettingsRepository.update @settings

      self.body = 'OK'

    end
  end
end
