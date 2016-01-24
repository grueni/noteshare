require 'bcrypt'
require_relative '../../../../lib/noteshare/modules/subdomain'
require 'keen'
require_relative '../../../../lib/noteshare/repositories/user_repository'

module SessionManager::Controllers::User

  class Create
    include SessionManager::Action
    include Noteshare::Subdomain
    include Keen

    def call(params)

      email =  params[:user]['email']
      user =  UserRepository.find_one_by_email email
      redirect_to '/error/1?The email you entered is already taken' if user

      new_user = User.create(params[:user])

      new_user.first_name = new_user.first_name || ''
      new_user.first_name = new_user.first_name.strip.capitalize

      new_user.last_name = new_user.last_name || ''
      new_user.last_name = new_user.last_name.strip.capitalize

      new_user.screen_name = new_user.screen_name || ''
      new_user.screen_name = new_user.screen_name .strip.downcase

      password = params[:user]['password']

      if new_user
        puts "app = SessionManager, controller = Create (User)".red
        new_node = NSNode.create_for_user(new_user)
        new_user.dict2['node'] = new_node.id
        UserRepository.update new_user
        new_user.login(password, session)
      end

      if new_user
        Keen.publish(:sign_ups, { :username => new_user.screen_name })
        redirect_to  basic_link new_user.node_name, "node/user/#{new_user.id}"
      else
        redirect_to '/error/2?Something went wrong with the signup process'
      end

    end

    #Fixme: we really shouldn't do this
    private
    def verify_csrf_token?
      false
    end

  end
end

