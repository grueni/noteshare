class Document
  include Lotus::Entity
  attributes :id, :author, :title, :tags, :meta,
    :createdAt, :modifiedAt, :text, :part

  def add_to(parent_document)
    DocumentRepository.persist(self) unless self.id
    if parent_document
      parent_document.part << self.id
    else
      parent_document.part = [self.id]
    end
    DocumentRepository.persist(parent_document)
  end

  def subdocument(k)
    DocumentRepository.find(part[k])
  end

  def subdocument_titles
    list = []
    part.each do |id|
      section = DocumentRepository.find(id)
      list << section.title
    end
    list
  end
  
  def compile
    compiled_text = self.text || 'Yo! '
    part.each do |id|
      section = DocumentRepository.find(id)
      compiled_text << "\n" << section.text
      if section.part
        compiled_text << section.compile
      end
    end
    compiled_text
  end

end
