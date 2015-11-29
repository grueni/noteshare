class GroupsRepository
  include Lotus::Repository

  def self.find_by_name(name)
    query do
      where(name: name)
    end
  end

end
