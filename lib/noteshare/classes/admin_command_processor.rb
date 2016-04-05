
# An AdminCommandProcessor parse
# and executes comands of the form
#    command a:b c:d etc
#    e.g., create-command token:foo123 verb:add_group_and_document group:linearstudent doc:1701
class AdminCommandProcessor


  def initialize(hash)
    @input = hash[:input]
    @user = hash[:user]
    receptor_node_id = hash[:node_id]
    @receptor_node = NSNodeRepository.find receptor_node_id if receptor_node_id
    @tokens = @input.split(' ').map{ |token| token.strip }
    @command_signature = get_command_signature(@tokens)
    @command = @tokens.shift
    @tokens = @tokens.map { |token| token.split(':') }
    @response = 'ok'
    @return_message = "<br/>\n\n<p><a  href='/node/#{@receptor_node.name}'>Back</a></p>\n"
  end

  def get_command_signature(array)
    tokens = array.dup
    # remove the arguments, i.e., map 'def:12' to 'def'
    tokens = tokens.map{ |str| str.split(':')[0] }
    tokens.join('_')
  end

  def execute
    parse_command
    self.send(@command_signature) if command_valid?
    @response = @error if @error
    @response
  end

  def command_valid?
    signatures = ['test']
    signatures << 'use_token'
    signatures << 'add_doc_to_group_token_days'
    signatures << 'add_document_to_group'
    signatures << 'add_group_token_days'
    signatures << 'add_doc_token_days'
    signatures << 'add_doc_and_group_token_days'
    signatures << 'change_author_id_from_to'
    signatures << 'add_node'
    signatures << 'remove_node'
    signatures << 'add_document'
    signatures << 'remove_document'
    signatures << 'add_group'
    signatures << 'remove_group'
    signatures << 'list_groups'

    if signatures.include? @command_signature
      true
    else
      @error = 'command not recognized'
      false
    end
  end


  # Break token into name, value, modifier,
  # where the modifier is optional
  def process_token
    if @arg_token.count == 2
      name, value = @arg_token
      instance_variable_set("@#{name}", value)
    elsif @arg_token.count == 3
      name, value, modifier = @arg_token
      instance_variable_set("@#{name}", value)
      instance_variable_set("@#{name}_modifier", modifier)
    else
      # @error = 'incorrect number of modifiers'
    end
    @error
  end

  # parse the token string, breaking
  # the original tokens into pairs
  # or triples of the form
  # (name, value, modifier),
  # then create instance variables
  # with name = name and value = value
  # For the modfiers, create an instance
  # variable with name = name_modifier
  # and value modifier.  These will
  # be used when the command is executed.
  def parse_command
    @arg_token = 'null'
    while @arg_token do
      @arg_token = @tokens.shift
      process_token if @arg_token
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
  def use_token
    return if authorize_user_for_level(1) == false
    @response = "ok: using token #{@token}"
    cp = CommandProcessor.new(user: @user, token: @token)
    @response = cp.execute
  end

  # Example: add group:yuuk token:yum111 days:30
  # Execution of the token adds the user to the group.
  def add_group_token_days
    return if authorize_user_for_level(2) == false
    token = "#{@user.screen_name}_#{@token}"
    group = "#{@user.screen_name}_#{@group}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [group], days_alive: @days.to_i)
  end

  # Example: change_author_id from:1 to:9
  # Execution of the token adds the use to the group.
  def change_author_id_from_to
    return if authorize_user_for_level(2) == false
    @response = AdminUtilities.change_author_id(@from, @to, 'fix')
    puts "change_author_id_from_to: #{@response}"
  end

  # Example: add doc:414 token:yum111 days:30
  # Execution of the token adds the document to the user's node
  def add_doc_token_days
    return if authorize_user_for_level(2) == false
    token = "#{@user.screen_name}_#{@token}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [@doc], days_alive: @days.to_i)
  end


  # Example: add doc:123 and_group:foo token:11 days:30
  # Execution of the token adds the document to the user's node ad adds the group to the user.
  def add_doc_and_group_token_days
    return if authorize_user_for_level(2) == false
    group = "#{@user.screen_name}_#{@and_group}"
    token = "#{@user.screen_name}_#{@token}"
    cp = CommandProcessor.new(token: token, user: @user)
    @error = cp.put(command: @command, args: [group, @doc], days_alive: @days.to_i)
  end

  # Example: add_document_to_group document:414 group:red
  def add_document_to_group
    # return if authorize_user_for_level(2) == false
    @document = DocumentRepository.find @document
    return if @document == nil
    return if @document.author_credentials2['id'].to_i != @user.id
    # group = "#{@user.screen_name}_#{@to_group}"
    group = "#{@user.screen_name}_#{@group}"
    @document = @document.root_document
    if @doc_modifier == 'read_only'
      @document.apply_to_tree(:acl_set, [:group, group, 'r'])
    else
      @document.apply_to_tree(:acl_set, [:group, group, 'rw'])
    end
    DocumentRepository.update @document
    @response = 'set_acl'
  end

  # Example: add node:poetry
  def add_node
    # return if authorize_user_for_level(2) == false
    node_name = @node
    @node_to_add = NSNodeRepository.find_one_by_name @node
    if @node_to_add
      neighbors = Neighbors.new(node: @receptor_node)
      neighbors.add!(node_name, 0.5)
      @response  =  "<p>Node #{@node} added to #{@receptor_node.name}</p>\n"
      @response << @return_message
    end
  end

  def remove_node
    # return if authorize_user_for_level(2) == false
    @node_to_remove = NSNodeRepository.find_one_by_name @node
    if @node_to_remove
      neighbors = Neighbors.new(node: @receptor_node)
      neighbors.remove!(@node)
      @response = "<p>Node #{@node} removed from #{@receptor_node.name}</p>\n"
      @response << @return_message
    end
  end


  def can_modify_document_status(document)
    return false if document == nil
    return false if @user == nil
    return false if @receptor_node == nil
    return false if @user.id != document.author_id
    return false if @user.id != @receptor_node.owner_id
    return true
  end

  # Add document to node list
  # The user must be the author of the document and
  # the owner of the node (for now)
  def add_document
    doc_id = @document
    @target_document = DocumentRepository.find doc_id
    if can_modify_document_status @target_document
      @receptor_node.append_doc(doc_id, 'author')
      @response = "Document #{@target_document.title} added"
      @response << @return_message
    else
      @response = 'Unauthorized'
      @response << @return_message
    end
  end

  # Remove document from node list
  # The user must be the author of the document and
  # the owner of the node (for now)
  def remove_document
    doc_id = @document
    @target_document = DocumentRepository.find doc_id
    if can_modify_document_status @target_document
      @receptor_node.remove_doc(doc_id)
      @response = "Document #{@target_document.title} removed"
      @response << @return_message
    else
      @response = 'Unauthorized'
      @response << @return_message
    end
  end

  def add_group
    return if authorize_user_for_level(2) == false
    manager = UserGroupManager.new(@user)
    new_group = "#{@user.screen_name}_#{@group}"
    manager.add new_group
    @response = "<p>Added: #{new_group}</p>"
    @response << "<h3>Groups</h3>"
    @response << manager.html_list
    @response << @return_message
  end

  def remove_group
    return if authorize_user_for_level(2) == false
    manager = UserGroupManager.new(@user)
    old_group = "#{@user.screen_name}_#{@group}"
    @response = "<p>Removed: #{old_group}</p>"
    manager.delete old_group
    @response << "<h3>Groups</h3>"
    @response << manager.html_list
    @response
  end

  def list_groups
    return if authorize_user_for_level(2) == false
    manager = UserGroupManager.new(@user)
    @response = "<h3>Groups</h3>"
    @response << manager.html_list
    @response << @return_message
  end

end