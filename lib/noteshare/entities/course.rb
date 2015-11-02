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
    lessons = self.associated_lessons
    puts "lessons.all.count = #{lessons.all.count}".magenta
    section_list = []
    lessons.all.each do |lesson|
      puts "processing id #{lesson.id} (#{lesson.title})".cyan
      section = lesson.to_document(author_name)
      # section.update_content
      # section.compile_with_render
      section_list << section
      section.add_to(master)
    end
    master.update_table_of_contents
    #Fixme: the below will not be necessary when we have lazy compilation for display
    # master.update_content
    # master.compile_with_render
    master
  end


end
