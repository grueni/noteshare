                                                                     ;# apps/web/controllers/home/index.rb
require 'asciidoctor'

module Web::Controllers::Home

  class Index
    include Web::Action
    include Lotus::Action::Session

    expose :settings, :active_item

    def call(params)

      puts "app = web, controller = switchboard".red
      puts session.inspect.cyan

      @settings = SettingsRepository.first


    end
    
  end
end