class Course
  include Lotus::Entity
  attributes :id, :title, :author, :author_id, :tags, :area, :created_at, :modified_at, :content

  def to_document(author_name = 'James Carlson')
    doc = DocumentRepository.create(NSDocument.new(title: self.title, author: author_name))
    doc.author_id = self.author_id
    doc.tags = self.tags
    doc.area = self.area
    doc.created_at = self.created_at
    doc.modified_at =  self.modified_at
    doc.content = self.content
    DocumentRepository.update(doc)
    return doc
  end

  def associated_lessons
    LessonRepository.select_for_course(self.id)
  end

  # Add all of the lessons associated to a given course
  def create_master_document(author_name = 'James Carlson')

    master = self.to_document(author_name)
    master.content ||= ''
    lessons = self.associated_lessons
    lesson_count = lessons.count

    stack = []
    last_node = master

    lessons.all.each do |lesson|
      section = lesson.to_document(author_name)
      stack == [] ?  delta = 2 : delta =  section.asciidoc_level - stack.last.asciidoc_level
      if delta >= 2
        stack.push(last_node)
        puts "push #{last_node.title}".magenta
      elsif delta <= 0
        x = stack.pop
        puts "pop #{x.title}".magenta
      end
      section.add_to(stack.last)
      puts "#{section.title} => #{stack.last.title}".blue
      last_node = section
    end

    master.update_table_of_contents
    lesson_count
  end


end
