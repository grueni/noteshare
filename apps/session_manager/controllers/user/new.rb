module SessionManager::Controllers::User
  class New
    include SessionManager::Action

    def call(params)

       puts "IN: SessionManager. New "
      # redirect_to '/'
    end
  end
end
