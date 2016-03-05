require_relative '../modules/display'
# require_relative '../modules/dict'

class User
  include Lotus::Entity
  include Noteshare::Display
  # include Noteshare::Dict

  attributes :id, :admin, :first_name, :last_name, :identifier, :email, :screen_name,
             :level, :password, :meta, :dict2, :password_confirmation, :groups, :docs_visited

  # http://hawkins.io/2012/07/rack_from_the_beginning/
  # https://blog.engineyard.com/2015/understanding-rack-apps-and-middleware
  # session = Rack::Session::Cookie.new(self, {
  #    :coder => Rack::Session::Cookie::Identity.new
  #})

  def initialize(hash)

    hash.each { |name, value| instance_variable_set("@#{name}", value) }
    @meta ||= '{}'

  end

  def info(title='User:')
    display(title, [:id, :first_name, :last_name, :screen_name, :email, :identifier ])
  end

  def self.create(user_params)
    new_user = User.new(user_params)
    if new_user.password == new_user.password_confirmation
      new_user.password = BCrypt::Password.create(new_user.password)
      new_user.set_identifier
      new_user.dict2 = {}
      UserRepository.create new_user
    end

  end

  def change_password(new_password)
    self.password = BCrypt::Password.create(new_password)
    UserRepository.update self
  end


  def delete_node
    node = NSNodeRepository.find node_id
    if node
      NSNodeRepository.delete node
    end
  end


  # Record the last node visited
  # if it is not the user's node
  def set_current_node(user, node)
    if node.id.to_i != user.node_id.to_i
      dict2['current_node_id'] = node.id
      dict2['current_node_name'] = node.name
      UserRepository.update self
    end
  end

  def get_current_node_name
    dict2['current_node_name']
  end

  def get_current_node_id
    dict2['current_node_id']
  end

  # Delete the user with given id
  # and also all dependent structures,
  # for now just the associated node
  def self.delete_with_dependents(user_id)
    puts "Deleting user #{user_id} and all dependent structures ...".red
    user = UserRepository.find user_id
    return if user == nil
    puts "deleting node #{user.node_id}".red
    user.delete_node
    puts "deleting documents ...".red
    DocumentRepository.delete_all_documents_of_author(user_id)
    puts "deleting user".red
    UserRepository.delete user
  end

  def login(password, session)
    auth = UserAuthentication.new(self.email, password)
    auth.authenticate
    authorized_user = auth.login(session)
    authorized_user
  end

  def credentials
    { id: id, first_name: first_name, last_name: last_name, identifier: identifier  }
  end



  def set_password(new_password)
    self.password = BCrypt::Password.create(new_password)
    UserRepository.update self
    return true
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def set_identifier
    self.identifier = Noteshare::Identifier.new().string
  end

  def set_identifier!
    self.identifier = Noteshare::Identifier.new().string
  end

  ##############################

  # Return the id of the node associated
  # to te user if  it exists.
  def node_id
    dict2['node']
  end

  def node_name
    node.name
  end

  def node
    id = dict2['node']
    NSNodeRepository.find id if id
  end

  def set_node(id_of_node)
    dict2['node'] = id_of_node
    UserRepository.update self
  end

  def remember_current_document_id(session)
    cid = session['current_document_id']
    return if cid == nil
    puts "In remember_current_document_id, cid = #{cid}"
    dict2['current_document_id'] = cid
    UserRepository.update self
  end

  def recall_current_document_id(session)
    session['current_document_id'] = dict2['current_document_id']
  end


  ##############################



  ##############################

  def self.list
    UserRepository.all.each do |u|
      puts "#{u.id}: #{u.first_name} #{u.last_name} (#{u.screen_name}) -- #{u.email}"
    end; nil
  end


  ################################
  #
  #  SEARCH
  #
  ################################

  # Return all root documents



end
