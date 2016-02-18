class UserGroupManager

  def initialize(user)
    @user = user
  end

  def list
    @user.groups
  end

  def add(group_name)
    @user.groups << group_name
    UserRepository.update @user
  end

  def delete(group_name)
    @user.groups.delete(group_name)
    UserRepository.update @user
  end


end