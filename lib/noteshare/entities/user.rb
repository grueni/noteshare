class User
  include Lotus::Entity
  attributes :id, :admin, :first_name, :last_name, :identifier, :email, :screen_name, :level, :password, :meta, :password_confirmation

  # http://hawkins.io/2012/07/rack_from_the_beginning/
  # https://blog.engineyard.com/2015/understanding-rack-apps-and-middleware
  # session = Rack::Session::Cookie.new(self, {
  #    :coder => Rack::Session::Cookie::Identity.new
  #})

  def initialize(hash)

    hash.each { |name, value| instance_variable_set("@#{name}", value) }
    @meta ||= '{}'

  end


  def self.create(user_params)
    new_user = User.new(user_params)
    if new_user.password == new_user.password_confirmation
      new_user.password = BCrypt::Password.create(new_user.password)
      new_user.password_confirmation = ''
      new_user.set_identifier
      UserRepository.create new_user
    end

  end

  def delete_node
    node = NSNodeRepository.find node_id
    if node
      NSNodeRepository.delete node
    end
  end

  # Delete the user with given id
  # and also all dependent structures,
  # for now just the associated node
  def self.delete_with_dependents(id)
    user = UserRepository.find id
    return if user == nil
    user.delete_node
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
    dict_lookup('node')
  end

  def set_node(id_of_node)
    dict_update({'node'=> id_of_node})
  end

  def remember_current_document_id(session)
    cid = session['current_document_id']
    puts "In remember_current_document_id, cid = #{cid}"
    dict_update({'current_document_id'=> cid})
  end

  def recall_current_document_id(session)
    session['current_document_id'] = dict_lookup('current_document_id')
  end


  ##############################

  def dict_set(new_dict)
    metadata = JSON.parse self.meta
    metadata[:dict] = new_dict
    self.meta = JSON.generate metadata
    puts self.class.name.green
    UserRepository.update self
  end

  def dict_update(entry)
    metadata = JSON.parse self.meta
    dict = metadata[:dict] || { }
    dict[entry.keys[0]] = entry.values[0]
    metadata[:dict] = dict
    self.meta = JSON.generate metadata
    UserRepository.update self
  end

  def dict_lookup(key)
    metadata = JSON.parse self.meta
    dict = metadata['dict'] || { }
    dict[key]
  end

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
