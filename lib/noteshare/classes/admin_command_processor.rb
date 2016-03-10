
# An AdminCommandProcessor parse
# and executes comands of the form
#    command a:b c:d etc
#    e.g., create-command token:foo123 verb:add_group_and_document group:linearstudent doc:1701
class AdminCommandProcessor


  def initialize(hash)
    @input = hash[:input]
    @user = hash[:user]
    @tokens = @input.split(' ').map{ |token| token.strip }
    @command = @tokens.shift
    @tokens = @tokens.map { |token| token.split(':') }
    puts "tokens: #{@tokens.inspect}".red
    @response = 'ok'
  end

  def execute
    return @error if valid?(@command) == false
    parse_command
    self.send(@command)
    puts "in execute, response = #{@response}".red
    @response = @error if @error
    @response
  end

  def valid?(command)
    commands = %w(add_group_and_document add_group add_document test use)
    if !commands.include?(command)
      @error = 'command not recognized'
      false
    else
      true
    end
  end

  def process_token
    # puts "@token: #{@acp_token.inspect}".cyan
    name, value = @acp_token
    puts "@#{name} = #{value}"
    instance_variable_set("@#{name}", value)
  end

  def parse_command
    @acp_token = 'null'
    while @acp_token do
      @acp_token = @tokens.shift
      process_token if @acp_token
    end
  end

  def authorize_user_for_level(level)
    if @user.level == nil or @user.level < level
      @error = 'insufficient privileges'
      return false
    else
      return true
    end
  end

  # Example: add_group token:yum111 group:yuuk days_alive:30
  def test
    return if authorize_user_for_level(1) == false
    @response = "TEST"
  end

  # Example: use token:abcd1234
  def use
    return if authorize_user_for_level(1) == false
    @response = "ok: using token #{@token}"
    cp = CommandProcessor.new(user: @user, token: @token)
    @response = cp.execute
  end

  # Example: add_group token:yum111 group:yuuk days_alive:30
  def add_group
    return if authorize_user_for_level(2) == false
    puts "@command: #{@command}".red
    cp = CommandProcessor.new(token: @token, user: @user)
    @error = cp.put(command: @command, args: [@group], days_alive: @days_alive.to_i)
  end

  # Example: add_document token:yum111 document:414 days_alive:30
  def add_document
    return if authorize_user_for_level(2) == false
    puts "@command: #{@command}".red
    cp = CommandProcessor.new(token: @token, user: @user)
    @error = cp.put(command: @command, args: [@document], days_alive: @days_alive.to_i)
  end

  # Example: add_group_and_document token:yum111 group:yuuk doc_id:666 days_alive:30
  def add_group_and_document
    return if authorize_user_for_level(2) == false
    puts "@command: #{@command}".red
    cp = CommandProcessor.new(token: @token, user: @user)
    @error = cp.put(command: @command, args: [@group, @doc_id], days_alive: @days_alive.to_i)
  end

end