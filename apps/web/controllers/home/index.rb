# apps/web/controllers/home/index.rb
module Web::Controllers::Home
  class Index
    include Web::Action

    expose :message

    def call(params)

      @settings = SettingsRepository.first

      @message = @settings.get_key('message')

      node = NSNode.from_http(request)
      if node
        redirect_to "/node/#{node.id}"
      end

    end
  end
end