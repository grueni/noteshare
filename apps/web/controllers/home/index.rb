# apps/web/controllers/home/index.rb
module Web::Controllers::Home
  class Index
    include Web::Action


    def call(params)

      if node = NSNode.from_http(request)
        redirect_to "/node/#{node.id}"
      end

    end
  end
end