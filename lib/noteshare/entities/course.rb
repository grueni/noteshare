require_relative '../../../lib/noteshare/modules/text_parse'

class Course
  include Lotus::Entity
  attributes :id, :title, :author, :author_id, :tags, :area, :created_at, :modified_at, :content, :course_attributes

  include TextParse

  # Create an NSDcoument from a Noteshare document
  def to_document(screen_name)
    user = UserRepository.find_one_by_screen_name(screen_name)
    return if user == nil

    doc = NSDocument.create(title: self.title, author_credentials: user.credentials)
    doc.author_id = self.author_id
    doc.tags = self.tags
    doc.area = self.area
    doc.created_at = self.created_at
    doc.modified_at =  self.modified_at
    doc.content = self.content
    DocumentRepository.update(doc)

    return doc
  end

  def tex_macros
    grab text: course_attributes, ad_prefix: 'doc', ad_suffix: 'texmacros'
  end

  def associated_lessons
    LessonRepository.select_for_course(self.id)
  end

  # Add all of the lessons associated to a given course
  def create_master_document(screen_name)

    master = self.to_document(screen_name)
    master.content ||= ''
    lessons = self.associated_lessons
    lesson_count = lessons.count

    _tex_macros = tex_macros
    if _tex_macros
      tex_macro_document =  NSDocument.create(title: 'Tex Macros', author_credentials: master.author_credentials)
      tex_macro_document.content = "\\(" + _tex_macros + "\\)"
      DocumentRepository.update tex_macro_document
      tex_macro_document.associate_to(master, 'texmacros')
    end

    stack = []
    last_node = master

    lessons.all.each do |lesson|
      section = lesson.to_document(screen_name)
      stack == [] ?  delta = 2 : delta =  section.asciidoc_level - stack.last.asciidoc_level
      if delta >= 2
        stack.push(last_node)
        puts "push #{last_node.title}".magenta
      elsif delta <= 0
        x = stack.pop
        puts "pop #{x.title}".magenta
      end
      section.add_to(stack.last)
      puts "#{section.title} => #{stack.last.title}".red
      puts "   --- #{section.identifier}".blue
      puts "   --- #{section.author_credentials}".blue
      last_node = section
    end

    # master.update_table_of_contents(force: true)
    lesson_count
  end


end
