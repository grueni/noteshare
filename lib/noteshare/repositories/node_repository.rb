class NSNodeRepository
  include Lotus::Repository

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
