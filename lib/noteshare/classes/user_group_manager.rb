class UserGroupManager

  def initialize(user)
    @user = user
  end

  def list
    @user.groups
  end

  def add(group)
    @user.groups << group.name
    UserRepository.update @user
  end

  def delete(group)
    @user.groups.delete(group.name)
    UserRepository.update @user
  end


end