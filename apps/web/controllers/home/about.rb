module Web::Controllers::Home
  class About
    include Web::Action
    expose :active_item

    def call(params)
      @active_item = 'home'
      puts params.env.inspect
    end
  end
end
