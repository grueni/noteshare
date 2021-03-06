module Admin::Controllers::Home
  class ProcessCommand
    include Admin::Action
    include Noteshare::Tool::CommandProcessor

    def call(params)
      puts "Howdy!"

      redirect_if_not_signed_in('Attempt to execute a command without being signed in')
      redirect_if_level_insufficient(1,'Attempt to execute a command by user with insufficient level')

      command = request.query_string
      if command == nil
        command = params['command_processor']['command']
        secret_token = params['command_processor']['secret_token']
        node_id = params['command_processor']['node_id']
      else
        command, secret_token = command.split('::')
        command = command.gsub('%20', ' ')
      end

      # check that the command originated from
      # a logged-in user clicking submit on the
      # approved form.
      # fixme: I think we need better authentication here
      if secret_token != ENV['COMMAND_SECRET_TOKEN']
        # halt 401
      end

      acp = CommandProcessor.new(user: current_user2, node_id: node_id, input: command)
      result = acp.execute


      self.body = body_message(result)
    end
  end
end
