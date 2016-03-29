module SessionManager::Views::User
  class Login
    include SessionManager::View

    def form
      puts "SessionManager LOGIN form".red

      form_for :user, '/session_manager/authenticate', class: 'user_setup_form' do

        label :email
        text_field :email

        label :password
        text_field :password, {type: 'password'}

        hidden_field :_csrf_token, value: session['_csrf_token']

        submit 'Log in', {id: 'login_button', class: 'green top_margin2' }

      end
    end

  end
end
