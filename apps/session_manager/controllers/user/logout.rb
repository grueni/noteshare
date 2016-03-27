require_relative '../../../../lib/modules/analytics'

module SessionManager::Controllers::User
  class Logout
    include SessionManager::Action
    include Keen

    def call(params)
      user = UserRepository.find session[:user_id]
      logout(user, session)

      Keen.publish(:sign_outs, { :username => user.screen_name }) if !user.admin

      case ENV['MODE']
        when 'LOCAL'
          url = 'localhost:2300'
          name = 'localhost'
        when 'LVH'
          stem = ENV['DOMAIN'].sub(/^\./,'') # delete leading '.'
          url = "http://#{stem}:#{ENV['PORT']}"
          name = stem
        else
          stem = ENV['DOMAIN'].sub(/^\./,'') # delete leading '.'
          name = stem
          url = "http://#{stem}"
      end

      if ENV['MODE'] == 'LOCAL'
      else
      end


      html = "<style>\n"
      html << "a { color: white; }\n"
      html << "</style>\n"
      html << "<div style='position:absolute;left:0;top:0;padding:3em;width:100%; height:100%;font-size:16pt;background-color:#444; color: white;'>You are now logged out\n<br/><a href='#{url}'>Back to #{name}</a></div>"



      self.body = html
      
    end
  end
end
