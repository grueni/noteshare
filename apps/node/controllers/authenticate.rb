module Node
  module Authentication

    def self.included(action)
      action.class_eval do
        before :authenticate!
        expose :current_user2
      end
    end

    private


    # do not require authentication for routes like
    # '/node/math' or /node/123' where the second
    # element is an id.  Do require it if the
    # second element is on a defined list, e.g., 'admin'
    # Require authentication for all others.
    def authenticate!
      # puts request.env.keys
      request_path = request.env['REQUEST_PATH']
      request_path_parts = (request_path.split '/').select{ |x| x.length > 0 }
      stem = request_path_parts[1] if request_path_parts.count > 1
      pass = authenticated?
      if request_path_parts.count == 2
        if ['admin', 'settings', 'new', 'create'].include? stem
          halt 401 unless pass
        end
      else
        halt 401 unless pass
      end
    end

    def authenticated?
      !!current_user2
    end

    def current_user2
      @current_user2 ||= UserRepository.find(session[:user_id])
    end

  end
end
