

# The UserGroupManager
class UserGroupManager

  def initialize(user)
    @user = user
  end

  def html_list
    output = "<ul>"
    @user.groups.each do |group|
      output << "  <li>#{group}</li>\n"
    end
    output << "</ul>"
    output
  end

  def list(option=nil)
    case option
      when 'bare'
        @user.groups
      when :html
        html_list
      else
        @user.groups
    end
  end

  def add(group_name)
    @user.groups << group_name
    UserRepository.update @user
  end

  def set(hash)
    group_name = hash[:group_name]
    document = hash[:document]
    permission = hash[:permission]
    case permission
      when :r
        document.acl_set(:group, group_name, 'r')
      when :rw
        document.acl_set(:group, group_name, 'rw')
      else
        document.acl_set(:group, group_name, '-')
    end
    UserRepository.update @user
  end

  def delete(group_name)
    @user.groups.delete(group_name)
    UserRepository.update @user
  end


end