class Groups
  include Lotus::Entity
  attributes :id, :owner_id, :name

  def self.create(hash)
    user = hash[:user]
    name = hash[:name]
    group_name = "#{user.screen_name}:#{name}"

    if GroupsRepository.find_by_name(group_name).all.count == 0
      group = Groups.new(name: group_name, owner_id: user.id)
      return GroupsRepository.create group
    else
      return nil
    end

  end

end
