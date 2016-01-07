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
      puts session.inspect.cyan
      if current_user(session)
        puts current_user_full_name(session).magenta
      else
        puts "NO USER".magenta
      end
      puts '----------------------------'.red


    end
    
  end
end