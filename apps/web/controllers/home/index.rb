# apps/web/controllers/home/index.rb
require 'rack/request'

module Web::Controllers::Home

  class Index
    include Web::Action
    include Lotus::Action::Session


    # include Lotus::Action::Session



    expose :message
    expose :active_item

    def call(params)

      puts 'controller home, index'.red
      puts "ENV['DOMAIN'] = #{ENV['DOMAIN']}".red

      puts session.inspect

      puts session.inspect.blue
      puts request.env["rack.session.unpacked_cookie_data"].to_s.red

      @settings = SettingsRepository.first

      @message = @settings.get_key('message')

    end
    
  end
end