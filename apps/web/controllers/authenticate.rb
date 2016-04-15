module Web
  module Authentication


    def self.included(action)
      action.class_eval do
        before :authenticate!
        expose :current_user2
      end
    end

    private

    def authenticate!
      # puts request.env.keys
      # request_path = request.env['REQUEST_PATH']
      # halt 401 unless request_path =~ /node\/public/ or authenticated?
    end

    def authenticated?
      !!current_user2
    end

    def current_user2
      @current_user2 ||= HR::UserRepository.find(session[:user_id])
    end

  end
end
