
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
    @response = 'foo'
  end

  def execute
    return @error if valid?(@command) == false
    parse_command
    self.send(@command)
    if @error
      @error
    else
      @response
    end
  end

  def valid?(command)
    commands = %w(add_group_and_document add_group add_document add_document_to_group test use)
    if !commands.include?(command)
      @error = 'command not recognized'
      false
    else
      true
    end
  end

  def process_token
    # puts "@token: #{@acp_token.inspect}".cyan
    if @acp_token.count == 2
      name, value = @acp_token
      instance_variable_set("@#{name}", value)
    elsif @acp_token.count == 3
      name, value, modifier = @acp_token
      instance_variable_set("@#{name}", value)
      instance_variable_set("@#{name}_modifier", modifier)
    else
      @error = 'incorrect number of modifierss'
    end
    @error
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
    @error = cp.execute
    @response = "executed command for token"
  end

  # Example: add_group token:yum111 group:yuuk days_alive:30
  # Execution of the token adds the use to the group.
  def add_group
    return if authorize_user_for_level(2) == false
    group = "#{@user.screen_name}_#{@group}"
    token = "#{@user.screen_name}_#{@token}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [group], days_alive: @days_alive.to_i)
    @response = "token: #{token}"
  end

  # Example: add_document token:yum111 document:414 days_alive:30
  # Execution of the tokenadds the document to the user's node
  def add_document
    return if authorize_user_for_level(2) == false
    token = "#{@user.screen_name}_#{@token}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [@document], days_alive: @days_alive.to_i)
    @reponse = 'Add document with tokn'
  end


      # Example: add_group_and_document token:yum111 group:yuuk doc_id:666 days_alive:30
  # Exection of the token adds th edocument to the user's node ad adds the group to the user.
  def add_group_and_document
    return if authorize_user_for_level(2) == false
    group = "#{@user.screen_name}_#{@group}"
    token = "#{@user.screen_name}_#{@token}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [group, @doc_id], days_alive: @days_alive.to_i)
  end

  # Example: add_document_to_group document:414 group:red
  def add_document_to_group
    return if authorize_user_for_level(2) == false
    _document = DocumentRepository.find @document
    if @document_modifier == 'read_only'
      _document.acl_set(:group, @group, 'r')
    else
      _document.acl_set(:group, @group, 'rw')
    end
    DocumentRepository.update _document
    @response = 'set_acl'
  end

end