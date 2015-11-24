# apps/web/controllers/home/index.rb
module Web::Controllers::Home
  class Index
    include Web::Action

    def subdomain_prefix
      request.host.split('.')[0]
    end

    def call(params)


      prefix = subdomain_prefix
      puts prefix
      if prefix
        node = NSNodeRepository.find_one_by_name(prefix)
        if node
          redirect_to "/node/#{node.id}"
        end
      end

    end
  end
end