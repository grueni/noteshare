# apps/web/controllers/home/index.rb
module Web::Controllers::Home
  class Index
    include Web::Action

    expose :message
    expose :active_item

    def call(params)

      puts request.inspect.cyan
      puts request.env
      puts request.env["rack.session.unpacked_cookie_data"].to_s.cyan
      puts request.env["rack.session.unpacked_cookie_data"]["domain"].to_s.red


      @active_item = 'home'
      @settings = SettingsRepository.first

      @message = @settings.get_key('message')

      node = NSNode.from_http(request)
      if node
        # redirect_to "/node/#{node.id}"
        redirect_to "/node/user/#{node.owner_id}"
      end
    end
  end
end