# apps/web/controllers/home/index.rb
require 'asciidoctor'

module Web::Controllers::Home

  class Index
    include Web::Action
    include Lotus::Action::Session

    expose :settings, :active_item

    def call(params)

      # puts request.env["rack.session.unpacked_cookie_data"].to_s.red

      @settings = SettingsRepository.first
      puts @settings.dict['message'].red
      puts @settings.dict['rendered_message'].cyan


      # @message = Asciidoctor.convert @settings.get_key('message')

    end
    
  end
end