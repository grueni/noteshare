module Admin
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
        expose :current_user2
      end
    end

    private

    def authenticate!
      halt 401 unless authenticated?
    end

    def authenticated?
      !!current_user
    end

    def current_user
      @current_user2 ||= UserRepository.find(session[:user_id])
    end
  end
end