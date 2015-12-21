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
    puts session.to_s.cyan

    if authenticate
      session[:user_id] = @user.id
      session[:current_document_id] = @user.recall_current_document_id(session)
      session[:current_image_id] = nil
      return @user
    else
      return nil
    end
  end

end


module SessionTools

  def logout(user, session)
    puts "LOGOUT".red
    user.remember_current_document_id(session)
    UserRepository.update user
    session[:current_document_id] = nil
    session[:current_image_id] = nil
    session[:user_id] = nil
  end

  def current_user(session)
    UserRepository.find session[:user_id]
  end

  def current_user_id(session)
    if current_user
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

  def current_user_full_name
    # SettingsRepository.first.owner
    user = UserRepository.first
    "#{user.first_name} #{user.last_name}"
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



  def grant

    # if there is no logged in user, grant access
    # if the world permission of the object matches
    # the code of action
    return @object.acl_get(:world) =~ /#{@action_code}/  if @user == nil

    # Grant permission if the world permission matches
    return true if @object.acl_get(:world) =~ /#{@action_code}/

    # From now on, we may assume that @user exists
    # and that world permissions have been processed

    # admin can do anything
    return true if @user.admin

    # process user permissions
    return true if @user.id == @object.creator_id && @object.acl_get(:user) =~ /#{@action_code}/

    # grant permission if the access control list permits it for the user
    return true if @object.acl_get "user:#{@user.screen_name}" =~ /#{@action_code}/

    # process group permissions for ACL
    @user.groups.each do |group|
      return true if @object.acl_get("group:#{group}") =~/#{@action_code}/
    end

    return false
  end



end