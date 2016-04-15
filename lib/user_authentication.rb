# https://github.com/rails/jquery-ujs/blob/master/src/rails.js#L59
# Take a look at Warden (mentioned by @solnic):
#
#  https://github.com/hassox/warden/wiki
#
# Info on Rack-based-apps:
#
# https://www.mobomo.com/2010/4/rack-middleware-and-applications-whats-the-difference/


 # https://github.com/lotus/lotus/blob/master/lib/lotus/action/csrf_protection.rb#L65


module HR
  class UserAuthentication

    def initialize(email, password)
      @email = email
      @password = password
      @user = UserRepository.find_one_by_email(@email)
    end

    def authenticate
      BCrypt::Password.new(@user.password) == @password if @user
    end

    def login(session)

      if authenticate
        session[:user_id] = @user.id
        session[:current_document_id] = @user.dict2['current_document_id']
        session[:current_image_id] = @user.dict2['current_image_id']
        if ENV['MODE'] == 'LOCAL'
          session[:domain] = ENV['DOMAIN']
        else
          session[:domain] = "#{@user.node_name}#{ENV['DOMAIN']}"
        end
        @user.dict2['show_overlay'] = 'yes' if  @user.dict2['show_overlay'] == nil
        @user.dict2['show_overlay_this_session'] = 'yes' unless @user.dict2['show_overlay'] == 'no'
        @user.dict2['search_scope'] ||= 'all'
        @user.dict2['search_mode'] ||= 'document'
        @user.dict2['current_document_id'] = ENV['GETTING_STARTED_ID'] if @user.dict2['current_document_id'] == nil
        @user.dict2['reader_view'] = 'titlepage' if @user.dict2['reader_view'] == nil
        session['current_document_id'] = @user.dict2['current_document_id']
        UserRepository.update @user
        return @user
      else
        return nil
      end
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

    # If the @object doesn't have an acl defined, used the root object's acl
    # if that makes sense
    if @object.class.name == 'NSDocument' and (@object.acl == nil || @object.acl == {})
      @object = @object.root_document
    end

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
    return true if @user.id == @object.author_credentials2['id'].to_i && @object.acl_get(:user) =~ /#{@action_code}/

    # grant permission if the access control list permits it for the user
    _info = @object.acl_get "user:#{@user.screen_name}"
    return true if (@object.acl_get "user:#{@user.screen_name}") =~ /#{@action_code}/


    # process group permissions for ACL
    @user.groups.each do |group|
      return true if @object.acl_get("group:#{group}") =~/#{@action_code}/
    end


    return false
  end



end

