module SessionManager::Views::User
  class New
    include SessionManager::View

    def form
      puts "form NEW USER".red

      form_for :user, '/session_manager/create_user', class: 'user_setup_form' do


        text_field :first_name
        label :first_name


        text_field :last_name
        label :last_name


        text_field :screen_name
        label :screen_name


        text_field :email
        label :email


        text_field :password, {type: 'password'}
        label :password

        text_field :password_confirmation, {type: 'password'}
        label :password_confirmation

        text_field :token
        label :token

        hidden_field :_csrf_token, value: session['_csrf_token']

        br
        br
        submit 'Create account', {id: 'create_uwer_button', class: 'green top_margin2;'}


      end
    end

  end
end
