class DocumentRepository
  include Lotus::Repository

  def self.find_by_title(title)
    query do
      where(title: title)
    end
  end

  def self.find_one_by_title(title)
    self.find_by_title(title).first
  end

end