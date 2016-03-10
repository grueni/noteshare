module Admin::Views::Home
  class Index
    include Admin::View

<<<<<<< HEAD
    def command_input_form
      form_for :command_processor, '/admin/process_command' do
        text_field :command, {id: 'command_form', style: 'margin-left:0;'}
        hidden_field :secret_token, value: ENV['COMMAND_SECRET_TOKEN'], placeholder: 'command'
        submit 'Execute',  class: "waves-effect waves-light btn", style: 'margin-top:3em;'
      end
    end
=======
>>>>>>> command

  end
end