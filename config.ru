require './config/environment'
# require 'rack/cors'

# use Rack::Static, :urls => ["/assets", "/images "], :root => "public"

=begin

use Rack::Cors do

  allow do
    origins 'localhost:2300', '127.0.0.1:2300',
            /^http:\/\/192\.168\.0\.\d{1,3}(:\d+)?$/
    # regular expressions can be used here

    resource '/file/list_all/', :headers => 'x-domain-token'
    resource '/file/at/*',
             # :methods => [:get, :post, :delete, :put, :patch, :options, :head],
             :methods => [:get, :post],
             :headers => 'x-domain-token',
             :expose  => ['Some-Custom-Response-Header'],
             :max_age => 600
    # headers to expose
  end

  allow do
    origins '*'
    resource '/public/*', :headers => :any, :methods => :get
  end

end

=end

run Lotus::Container.new
