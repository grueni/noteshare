class User
  include Lotus::Entity
  attributes :id, :first_name, :last_name, :identifier, :email, :screen_name, :level, :password, :meta, :password_confirmation

  # http://hawkins.io/2012/07/rack_from_the_beginning/
  # https://blog.engineyard.com/2015/understanding-rack-apps-and-middleware
  # session = Rack::Session::Cookie.new(self, {
  #    :coder => Rack::Session::Cookie::Identity.new
  #})

  def initialize(hash)

    hash.each { |name, value| instance_variable_set("@#{name}", value) }
    @meta ||= '{}'

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

  # Return the id of the node associate
  # to te user if  it exists.
  def node_id
    dict_lookup('node')
  end

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
