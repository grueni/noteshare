class CommandProcessor


  def initialize(user, token_presented)
    @user = user
    @token_presented = token_presented
  end

  def put(command, args, days_alive)
    c = Command.new(token: @token_presented, author_id: @user.id, command: command, args: args)
    c.created_at = DateTime.now
    c.expires_at = c.created_at + days_alive
    CommandRepository.create c
    c
  end

  def get
    @command  = CommandRepository.with_token(@token_presented)
    if @command
      puts @command.inspect.red
    else
      puts "No matching token"
    end
  end



end