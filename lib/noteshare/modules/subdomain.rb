
module Noteshare
  module Subdomain
    # Example: basic_link('code', 'foobar')
    # => "http://code.localhost:2300/foobar"
    # if ENV['HOST'] = '.localhost'
    #
    # Example: basic_link(:none, 'home')
    # => "http://scripta.io/home"
    # if ENV['HOST'] = 'scripta.io'
    #
    def basic_link(prefix, suffix)
      prefix == :none ? prefix = '' : prefix = "#{prefix}."
      suffix == :none ? suffix = '' : suffix = "/#{suffix}"
      return suffix if ENV['MODE'] == 'LOCAL'
      stem = ENV['DOMAIN'].sub(/^\./,'') # delete leading '.'
      puts "1. stem: #{stem}"
      puts "port: #{ENV['PORT']}"

      stem = "#{stem}:#{ENV['PORT']}" if ENV['MODE'] == 'LVH'
      puts "2. stem: #{stem}"
      link = "http://#{prefix}#{stem}#{suffix}"
      puts "prefix: #{prefix}"
      puts "stem: #{stem}"
      puts "suffix: #{suffix}"
      puts "basic_link: #{link}".red
      link
    end


  end
end