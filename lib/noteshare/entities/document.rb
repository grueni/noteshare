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

  def compile
    puts "**** COMPILE ****"
    compiled_text = self.text || 'Yo! '
    puts "ct: #{compiled_text}"
    puts "number of parts = #{part.count}"
    part.each do |id|
      section = DocumentRepository.find(id)
      puts "#{id}: #{section.title}"
      compiled_text << "\n" << section.text
      puts "ct: #{compiled_text}"
    end
    compiled_text
  end

end
