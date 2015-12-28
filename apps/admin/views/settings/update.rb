module Admin::Views::Settings
  class Update
    include Admin::View

    def form
      puts "Admin::Views::Settings, Update".red

      form_for :update_settings, '/admin/do_update_message', class: '' do

        label :message
        text_area :message, settings.dict['message']

        submit 'Update message',  class: "green"

        submit 'Cancel', class: 'green'

      end


    end

  end

end
