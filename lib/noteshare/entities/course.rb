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
    puts "Lesson to import: #{lesson_count}".red

    puts "A".red

    _tex_macros = tex_macros
    if _tex_macros
        puts "-- a1".cyan
      tex_macro_document =  NSDocument.create(title: 'Tex Macros', author_credentials: master.author_credentials)
        puts "-- a2".cyan
      tex_macro_document.content = "\\(" + _tex_macros + "\\)"
        puts "-- a3".cyan
      DocumentRepository.update tex_macro_document
        puts "-- a4".cyan
      tex_macro_document.associate_to(master, 'texmacros')
    end

    puts "B".red

    stack = []
    last_node = master

    puts "C".red

    count = 0
    lessons.all.each do |lesson|

      count = count + 1
      puts "#{count}: #{lesson.id}, #{lesson.title}".cyan

      begin

        section = lesson.to_document(screen_name)
        if lesson.aside and lesson.aside.length > 1
          section.add_associate(title: 'Notes', content: lesson.aside, type: 'aside')
        end
        stack == [] ?  delta = 2 : delta =  section.asciidoc_level - stack.last.asciidoc_level
        if delta >= 2
          stack.push(last_node)
        elsif delta <= 0
          x = stack.pop
        end
        section.add_to(stack.last)
        last_node = section

      rescue

        puts "Error in importing #{lesson.title} (#{id})".red

      end



    end
    return master
  end

  def create_master_document1(screen_name)

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
      elsif delta <= 0
        x = stack.pop
      end
      section.add_to(stack.last)
      last_node = section
    end
    return master
  end


end
