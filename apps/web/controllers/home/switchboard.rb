
require_relative '../../../../lib/ui/links'

module Web::Controllers::Home

  class Switchboard
    include Web::Action
    include Noteshare::Core::Node

    expose :active_item

    def call(params)
      @active_item = 'home'
      node = NSNode.from_http(request)
      referer = request.env["HTTP_REFERER"]
      hash = {user: current_user2, node: node, referer: referer}
      result = Noteshare::Interactor::Web::Switchboard.new(hash).call
      redirect_to result.redirect_path || '/'
    end
  end
end
