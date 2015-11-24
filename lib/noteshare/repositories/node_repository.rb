class NSNodeRepository
  include Lotus::Repository

  def self.find_by_name(name)
    query do
      where(name: name)
    end
  end

  def self.find_one_by_name(name)
    self.find_by_name(name).first
  end

  def self.for_owner_id_aux(owner_id)
    query do
      where(owner_id: owner_id)
    end
  end

  def self.for_owner_id(owner_id)
    result = self.for_owner_id_aux(owner_id)
    result.first
  end


end
