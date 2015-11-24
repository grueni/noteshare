module Web::Controllers::Home
  class About
    include Web::Action

    def call(params)
      puts params.env.inspect
    end
  end
end
