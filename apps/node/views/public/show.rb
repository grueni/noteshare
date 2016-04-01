module Node::Views::Public
  class Show
    include Node::View

    def command_input_form
      form_for :command_processor, '/admin/process_command' do
        text_field :command, {id: 'command_form_node', style: '', placeholder: 'Example command -- add node:poetry'}
        hidden_field :secret_token, value: ENV['COMMAND_SECRET_TOKEN']
      end
    end


  end
end
