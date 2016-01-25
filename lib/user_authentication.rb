# https://github.com/rails/jquery-ujs/blob/master/src/rails.js#L59
# Take a look at Warden (mentioned by @solnic):
#
#  https://github.com/hassox/warden/wiki
#
# Info on Rack-based-apps:
#
# https://www.mobomo.com/2010/4/rack-middleware-and-applications-whats-the-difference/


 # https://github.com/lotus/lotus/blob/master/lib/lotus/action/csrf_protection.rb#L65

class UserAuthentication

  # include Lotus::Web::Action

  def initialize(email, password)
    @email = email
    @password = password
    @user = UserRepository.find_one_by_email(@email)
  end

  def authenticate
    BCrypt::Password.new(@user.password) == @password if @user
  end

  def login(session)
    puts "Enter UserAuthenticator # login ".magenta

    if authenticate
      session[:user_id] = @user.id
      session[:current_document_id] = @user.dict2['current_document_id']
      session[:current_image_id] = @user.dict2['current_image_id']
      session[:domain] = "#{@user.node_name}#{ENV['DOMAIN']}"
      return @user
    else
      return nil
    end
  end

end

require 'keen'
module SessionTools
  include Keen

  def logout(user, session)
    puts "LOGOUT".red
    if user
      user.remember_current_document_id(session)
      UserRepository.update user
    end
    session[:current_document_id] = nil
    session[:current_image_id] = nil
    session[:user_id] = nil
  end

  def current_user(session)
    UserRepository.find session[:user_id]
  end

  def current_user_id(session)
    if current_user(session)
      return current_user.id
    else
      return nil
    end
  end

  def current_user_is_admin?(session)
    user = UserRepository.find session[:user_id]
    return false if user == nil
    return user.admin
  end

  def current_user_full_name(session)
    user = UserRepository.find session[:user_id]
    "#{user.first_name} #{user.last_name}"
  end

  # See
  #    http://lotusrb.org/guides/actions/share-code/
  # for a better solution
  def redirect_if_not_admin(message)
    cu = current_user(session)
    if cu == nil or cu.admin == false
      if cu == nil
        Keen.publish(:unauthorized_access_attempt, {user: 'nil', message: message})
      else
        Keen.publish(:unauthorized_access_attempt, {user: cu.screen_name, message: message})
      end
      # redirect_to '/error/0?Something went wrong.'
      halt(401)
    end
  end

  def redirect_if_not_signed_in(message)
    cu = current_user(session)
    if cu == nil
      Keen.publish(:unauthorized_access_attempt, {user: 'nil', message: message})
      # redirect_to '/error/1?Something went wrong.'
      halt(401)
    end
  end


end

class Permission

  # Visiblity of document is 0 = private (user only)
  # 1 = group, 1, 2, 3 =
  # private (user on)

  def initialize(user, action, object)
    @user = user
    @object = object
    action_code_map = { read: 'r', edit: 'w', update: 'w', create: 'w', delete: 'w'}
    @action_code = action_code_map[action]
  end

  def self.is_given?(subject, verb, object)
    Permission.new(subject, verb, object).grant
  end

  def self.is_not_given?(subject, verb, object)
    !Permission.new(subject, verb, object).grant
  end

  def grant


    return false if @object == nil

    # if there is no logged in user, grant access
    # if the world permission of the object matches
    # the code of action
    # puts "A"
    return @object.acl_get(:world) =~ /#{@action_code}/  if @user == nil

    # puts "B"
    # Grant permission if the world permission matches
    return true if @object.acl_get(:world) =~ /#{@action_code}/

    # From now on, we may assume that @user exists
    # and that world permissions have been processed

    # puts "C"
    # admin can do anything
    return true if @user.admin

    # puts "D"
    # process user permissions
    return true if @user.id == @object.creator_id && @object.acl_get(:user) =~ /#{@action_code}/

    # puts "E"
    # grant permission if the access control list permits it for the user
    puts "action code: [#{@action_code}]".red
    _info = @object.acl_get "user:#{@user.screen_name}"
    puts "acl says: [#{_info}]".red
    return true if (@object.acl_get "user:#{@user.screen_name}") =~ /#{@action_code}/

=begin
    # process group permissions for ACL
    if @user.groups
      @user.groups.each do |group|
        return true if @object.acl_get("group:#{group}") =~/#{@action_code}/
      end
    end
=end

    # puts "F"
    return false
  end



end