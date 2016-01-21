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
          name = localhost
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
      self.body = "<div style='position:absolute;left:80px;top:80px;'>You are now logged out\n<br/><a href='#{url}'>Back to #{name}</a></div>"
    end
  end
end
