require 'asciidoctor'

module Admin::Controllers::Settings
  class DoUpdateMessage
    include Admin::Action

    expose :active_item

    def call(params)
      @active_item = 'admin'
      raw_new_message = params['update_settings']['message']
      @settings = SettingsRepository.first
      @settings.dict['message'] = raw_new_message
      @settings.dict['rendered_message'] = Asciidoctor.convert @settings.dict['message']
      SettingsRepository.update @settings

      redirect_to "/"

    end
  end
end
