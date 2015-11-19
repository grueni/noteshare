module SessionManager::Views::User
  class New
    include SessionManager::View

    def form
      puts ">> form NEW USER".red

      form_for :user, '/session_manager/create_user', class: 'user_setup_form' do

        label :first_name
        text_field :first_name

        label :last_name
        text_field :last_name

        label :screen_name
        text_field :screen_name

        label :email
        text_field :email

        label :password
        text_field :password, {type: 'password'}

        label :password_confirmation
        text_field :password_confirmation, {type: 'password'}

        submit 'Create account', {id: 'create_uer_button', style: 'margin-top:1em'}

      end
    end

  end
end
