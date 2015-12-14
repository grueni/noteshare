require 'asciidoctor'

module Admin::Controllers::Settings
  class DoUpdateMessage
    include Admin::Action

    expose :active_item

    def call(params)
      @active_item = 'admin'
      raw_new_message = params['update_settings']['message']
      # new_message = Asciidoctor.convert raw_new_message
      @settings = SettingsRepository.first
      @settings.set_key('message', raw_new_message)
      SettingsRepository.update @settings

      redirect_to "/node/user/#{current_user(session).id}"

    end
  end
end
