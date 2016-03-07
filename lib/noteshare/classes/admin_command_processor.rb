
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
    @error = 'ok'
  end

  def execute
    valid?(@command)
    parse_command
    self.send(@command)
    @error
  end

  def valid?(command)
    commands = %w(add_group_and_document add_group add_document)
    if commands.include?(command)
      @error = 'ok'
    else
      @error = 'command not recognized'
      return @error
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

  # Example: add_group token:yum111 group:yuuk days_alive:30
  def add_group
    puts "@command: #{@command}".red
    cp = CommandProcessor.new(token: @token, user: @user)
    cp.put(command: @command, args: [@group], days_alive: @days_alive.to_i)
  end

  # Example: add_document token:yum111 document:414 days_alive:30
  def add_document
    puts "@command: #{@command}".red
    cp = CommandProcessor.new(token: @token, user: @user)
    cp.put(command: @command, args: [@document], days_alive: @days_alive.to_i)
  end

  # Example: add_group_and_document token:yum111 group:yuuk doc_id:666 days_alive:30
  def add_group_and_document
    puts "@command: #{@command}".red
    cp = CommandProcessor.new(token: @token, user: @user)
    cp.put(command: @command, args: [@group, @doc_id], days_alive: @days_alive.to_i)
  end


end