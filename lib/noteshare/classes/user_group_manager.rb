class UserGroupManager

  def initialize(user)
    @user = user
  end

  def list
    @user.groups
  end

  def add(group_name)
    puts "Adding #{group_name} to user #{@user.screen_name}"
    @user.groups << group_name
    UserRepository.update @user
  end

  def add_document_to_group(group_name)
    puts "Adding #{group_name} to user #{@user.screen_name}"
    @user.groups << group_name
    UserRepository.update @user
  end

  def delete(group_name)
    @user.groups.delete(group_name)
    UserRepository.update @user
  end


end