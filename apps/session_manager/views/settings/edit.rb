module SessionManager::Views::Settings
  class Edit
    include SessionManager::View

    def form
      puts ">> form NEW USER".red

      form_for :user_settings, '/session_manager/update_settings', class: 'user_setup_form' do

        label :user_settings
        text_area :settings_as_text, unpacked_user_settings

        submit 'Update settings', {id: 'update_settings_button', class: 'green top_margin2;'}

        submit 'Cancel'  , {id: 'cancel_update_settings_button', class: 'green top_margin2;'}

      end
    end

  end
end
