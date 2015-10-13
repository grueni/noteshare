class DocumentRepository
  include Lotus::Repository

  def self.find_by_title(title)
    query do
      where(title: title)
    end
  end
end