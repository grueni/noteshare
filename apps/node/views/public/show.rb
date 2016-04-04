module Node::Views::Public
  class Show
    include Node::View

    def command_input_form_old
      form_for :command_processor, '/admin/process_command' do
        text_field :command, {id: 'command_form_node', style: '', placeholder: 'Example command -- add node:poetry'}
        hidden_field :secret_token, value: ENV['COMMAND_SECRET_TOKEN']
      end
    end

    def command_input_form(node)
      form_for :command_processor, '/admin/process_command' do
        text_field :command, {id: 'command_form_node', style: '', placeholder: 'Example command -- add node:poetry'}
        hidden_field :secret_token, value: ENV['COMMAND_SECRET_TOKEN']
        hidden_field :node_id, value: node.id
      end
    end


  end
end
