class Lesson
  include Lotus::Entity
  attributes :id, :title, :content, :author_id, :course_id, :created_at, :modified_at,
             :tags, :area, :sequence

  def to_document(author_name = 'James Carlson')
    doc = DocumentRepository.create(NSDocument.new(title: self.title, author: author_name))
    doc.author_id = self.author_id
    doc.tags = self.tags
    doc.area = self.area
    doc.created_at = self.created_at
    doc.modified_at =  self.modified_at
    doc.content = self.content
    DocumentRepository.persist(doc) if !doc.id
    return doc
  end

end



