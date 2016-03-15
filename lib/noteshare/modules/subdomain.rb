
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
    def basic_link1(prefix, suffix)
      if ENV['USE_SUBDOMAINS'] == 'yes'
        prefix == :none ? prefix = '' : prefix = "#{prefix}."
      else
        prefix = ''
      end
      suffix == :none ? suffix = '' : suffix = "/#{suffix}"
      return suffix if ENV['MODE'] == 'LOCAL'
      stem = ENV['DOMAIN'].sub(/^\./,'') # delete leading '.'
      stem = "#{stem}:#{ENV['PORT']}" if ENV['MODE'] == 'LVH'
      link = "http://#{prefix}#{stem}#{suffix}"
      link
    end

    def basic_link(prefix, suffix)
      prefix == :none ? prefix = '' : prefix = "#{prefix}."
      prefix = ''
      suffix == :none ? suffix = '' : suffix = "/#{suffix}"
      return suffix if ENV['MODE'] == 'LOCAL'
      stem = ENV['DOMAIN'].sub(/^\./,'') # delete leading '.'
      stem = "#{stem}:#{ENV['PORT']}" if ENV['MODE'] == 'LVH'
      link = "http://#{prefix}#{stem}#{suffix}"
      puts "prefix; #{prefix}, stem: #{stem} ,suffix: #{suffix}".green
      puts "basic_link: #{link}".green
      link
    end


  end
end