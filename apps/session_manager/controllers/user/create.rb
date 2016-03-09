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

      puts params[:user]

      email =  params[:user]['email']
      redirect_to '/error/1?You must enter an email address' if email == ''
      redirect_to '/error/1?You must enter a VALID email address' if !(email =~ /\A[a-zA-Z].*@[a-zZ-Z].*\.[a-zA-Z]*/)
      user =  UserRepository.find_one_by_email email
      redirect_to '/error/1?The email you entered is already taken' if user


      first_name = (params[:user]['first_name'] || '').strip.capitalize
      if first_name == ''
        redirect_to '/error/1?Your did not fill in your first name'
      end


      last_name = (params[:user]['last_name'] || '').strip.capitalize
      if last_name == ''
        redirect_to '/error/1?Your did not fill in your last name'
      end

      screen_name = params[:user]['screen_name'] || ''
      puts "screen_name length: #{screen_name.length}".red
      if screen_name.length < 4 or screen_name =~ / /
        redirect_to '/error/1?Your screen name must have at least 4 characters with no spaces'
      end
      screen_name = screen_name.downcase

      user2 =  UserRepository.find_one_by_screen_name screen_name
      redirect_to '/error/1?The screen_name you entered is already taken' if user2

      password = params[:user]['password']
      puts "password: #{password}".red
      redirect_to '/error/1?You must enter a password.' if password == ''
      redirect_to '/error/1?Your password must have at least 8 characters.' if password.length < 8

      password_confirmation = params[:user]['password_confirmation']
      redirect_to '/error/1?You must enter a password_confirmation.' if password_confirmation == ''
      puts "password_confirmatin: #{password_confirmation}".red
      if password != password_confirmation
        redirect_to '/error/1?The passwords did not match' if user2
      end

      new_user = User.create(first_name: first_name, last_name: last_name, email: email, screen_name: screen_name, password: password, password_confirmation: password_confirmation)

      if new_user
        puts "app = SessionManager, controller = Create (User)".red

        new_node = NSNode.create_for_user(new_user)
        new_node.publish_document(id: ENV['GETTING_STARTED_ID'], type: 'reader')
        NSNodeRepository.update new_node

        new_user.dict2['node'] = new_node.id
        new_user.dict2['root_documents_created'] = 0
        UserRepository.update new_user

        content = "This is a place to practice writing. _Go for it!_\n"

        sd = SetupDocument.new(author: new_user, title: "#{new_user.screen_name.capitalize} Notes", content: content)
        sd.make

        token = params[:user]['token']
        if token != ''
          cp = CommandProcessor.new(user: new_user, token: token)
          cp.execute
        end

        new_user.login(password, session)
      end

      if new_user
        Keen.publish(:sign_ups, { :username => new_user.screen_name })
        redirect_to  basic_link new_user.node_name, "node/34"
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

