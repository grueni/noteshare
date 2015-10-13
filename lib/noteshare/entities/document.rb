class Document
  include Lotus::Entity
  attributes :id, :author, :title, :tags, :meta,
    :createdAt, :modifiedAt, :content, :part

  # *section.add_to(doc)* appends the id of *section*
  # to the array *doc.part*
  def add_to(parent_document)
    DocumentRepository.persist(self) unless self.id
    if parent_document
      parent_document.part << self.id
    else
      parent_document.part = [self.id]
    end
    DocumentRepository.persist(parent_document)
  end

  # *doc.subdocment(k)* returns the k-th
  # subdocument of *doc*
  def subdocument(k)
    DocumentRepository.find(part[k])
  end

  # *doc.subdocument_titles* returns a list of the
  # titles of the sections of *document*.
  def subdocument_titles
    list = []
    part.each do |id|
      section = DocumentRepository.find(id)
      list << section.title
    end
    list
  end

  # *doc.compile* concatenates the contents
  # of *doc* with the compiled text of
  # each section of *doc*.  The sections
  # array is determined by #part, which is
  # a persistent array of integers which
  # represent the id's of the sections of
  # *doc*.
  def compile
    compiled_text = self.content || 'Yo! '
    part.each do |id|
      section = DocumentRepository.find(id)
      compiled_text << "\n" << section.content
      if section.part
        compiled_text << section.compile
      end
    end
    compiled_text
  end

end
