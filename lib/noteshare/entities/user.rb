class User
  include Lotus::Entity
  attributes :id, :first_name, :last_name, :email, :screen_name, :level, :password, :meta, :password_confirmation

  # http://hawkins.io/2012/07/rack_from_the_beginning/
  # https://blog.engineyard.com/2015/understanding-rack-apps-and-middleware
  # session = Rack::Session::Cookie.new(self, {
  #    :coder => Rack::Session::Cookie::Identity.new
  #})



  def set_password(new_password)
    self.password = BCrypt::Password.create(new_password)
    UserRepository.update self
    return true
  end

  # Return the id of the node associate
  # to te user if  it exists.
  def node_id
    if self.meta
      JSON.parse(self.meta)['node']
    end
  end


end
