class LessonRepository
  include Lotus::Repository

  def self.for_course(id)
    query do
      where(course_id: id).
          order(:sequence)
    end
  end

  def self.sections_of_course(id)
    sections = self.for_course(id)
    output = ''
    sections.all.each do |s|
      output << "#{s.sequence}, #{s.id}: #{s.title}\n"
    end
    output
  end

  def to_document(author_name = 'James Carlson')
    doc = NSDocument.new(title: self.title, author: author_name)
    doc.content = self.content
    return doc
  end



end
