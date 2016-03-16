
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
      if ENV['USE_SUBDOMAINS'] == 'yes'
        prefix == :none ? prefix = '' : prefix = "#{prefix}."
      else
        prefix = ''
      end
      puts "basic_link, prefix = #{prefix}".green
      suffix == :none ? suffix = '' : suffix = "/#{suffix}"
      return suffix if ENV['MODE'] == 'LOCAL'
      stem = ENV['DOMAIN'].sub(/^\./,'') # delete leading '.'
      stem = "#{stem}:#{ENV['PORT']}" if ENV['MODE'] == 'LVH'
      link = "http://#{prefix}#{stem}#{suffix}"
      link
    end

    def get_prefix(session)
      if ENV['USE_SUBDOMAINS'] == 'yes'
        user = current_user(session)
        if user
          prefix = user.screen_name
        else
          prefix = '' # node.name
        end
      else
        prefix = ''
      end
      prefix
    end


  end
end