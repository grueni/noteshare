module SessionManager::Views::User
  class Login
    include SessionManager::View

    def form
      puts ">> form NEW USER".red

      form_for :user, '/session_manager/authenticate', class: 'user_setup_form' do

        label :email
        text_field :email

        label :password
        text_field :password

        submit 'Log in', {id: 'login_button', style: 'margin-top:1em'}

      end
    end

  end
end
