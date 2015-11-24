# apps/web/controllers/home/index.rb
module Web::Controllers::Home
  class Index
    include Web::Action

    def call(params)

      puts params.env.inspect.to_s.blue
      puts 'HTTP_HOST: '+ params.env['HTTP_HOST'].inspect.to_s.red
      puts "REQUEST_PATH: " + params.env["REQUEST_PATH"].inspect.to_s.red
      puts "HTTP_REFERER: " + params.env["HTTP_REFERER"].inspect.to_s.red


    end
  end
end