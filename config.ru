require './config/environment'

# use Rack::Static, :urls => ["/assets", "/images "], :root => "public"

run Lotus::Container.new
