class Course
  include Lotus::Entity
  attributes :id, :title, :author, :author_id, :tags, :area, :created_at, :modified_at, :content

  def to_document(author_name = 'James Carlson')
    doc = NSDocument.new(title: self.title, author: author_name)
    doc.id =  self.id
    doc.author_id = self.author_id
    doc.tags = self.tags
    doc.area = self.area
    doc.created_at = self.created_at
    doc.modified_at =  self.modified_at
    doc.content = self.content
    return doc
  end

  


end
