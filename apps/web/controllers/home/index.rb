                                                                     ;# apps/web/controllers/home/index.rb
require 'asciidoctor'

module Web::Controllers::Home

  class Index
    include Web::Action
    include Lotus::Action::Session

    expose :settings, :active_item

    # cache_control :public, max_age: 6000
    # => Cache-Control: public, max-age: 600

    def call(params)
      @settings = AppSettings::SettingsRepository.first
    end
    
  end
end