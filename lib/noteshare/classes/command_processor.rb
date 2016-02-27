class CommandProcessor


  def initialize(hash)
    @user = hash[:user]
    @token_presented = hash[:token]
  end


  # hash = { 'command_verb' => the_command_verb, 'args' => the_args, 'days_alive' => N}
  def put(hash)
    puts "hash: #{hash.to_s}".red
    c = Command.new(token: @token_presented,
                    command_verb: hash[:command], args: hash[:args], days_alive: hash[:args])
    c.created_at = DateTime.now
    c.expires_at = c.created_at + hash['days_alive'].to_i
    CommandRepository.create c
    c
  end

  def get
    @command_object = CommandRepository.with_token(@token_presented)
    @command_verb = @command_object.command_verb
    @args = @command_object.args
    puts "get, command_verb: #{@command_verb}"
    puts "get, args: #{@args}"
  end

  def execute
    get
    puts "in execute, expires_at #{@command_object.expires_at}".yellow
    puts (DateTime.now > @command_object.expires_at).to_s.red
    execute_command unless DateTime.now > @command_object.expires_at
  end

  def execute_command
    puts "execute_command".red
    puts "args #{@args}".cyan
    case @command_verb
      when 'add_group_to_user'
        puts "add_group_to_user, args = #{@args}"
        ugm = UserGroupManager.new(@user)
        ugm.add(@args[0])
      else
        puts 'unrecognized command'
    end
  end



end