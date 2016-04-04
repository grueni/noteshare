module Node::Views::User
  class Show
    include Node::View

    def title(node)
      if node
        "Node #{node.name}"
      else
        "No node set up"
      end
    end

    def owner_line(node)
      if node
        user = UserRepository.find(node.owner_id)
        "This is #{user.screen_name}'s node" if user
      else
        ""
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
