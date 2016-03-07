module Admin::Controllers::Home
  class ProcessCommand
    include Admin::Action

    def call(params)

      redirect_if_not_admin('Attempt to change system message (admin, settings, do update messge)')

      @user = current_user(session)

      command = params['command_processor']['command']
      secret_token = params['command_processor']['secret_token']

      if secret_token == ENV['COMMAND_SECRET_TOKEN']
        authorized = 'YES'
      else
        authorized = 'NO'
        halt 401
      end

      acp = AdminCommandProcessor.new(user: @user, input: command)
      result = acp.execute


      self.body = body_message(result)
    end
  end
end
