require_relative '../../../lib/noteshare/modules/text_parse'


### INTERFACE ###
# create_master_document
class Course
  include Lotus::Entity
  attributes :id, :title, :author, :author_id, :tags, :area, :created_at, :modified_at, :content, :course_attributes

  include TextParse



  ### INTERFACE ###

  # Create a root document for the given course with
  # authorship determinded by the screen name.
  # Then add all of the lessons of the course
  # to the master document.
  def create_master_document(screen_name)

    # Set up master document
    master = self.to_document(screen_name)
    master.content ||= ''
    titlepage_image_id = self.titlepage_image
    if  titlepage_image_id
      master.dict['titlepage_image'] = titlepage_image_id
    end
    lessons = self.associated_lessons
    lesson_count = lessons.count
    puts "Lessons to import: #{lesson_count}".red

    # Handle tex macros if necessary
    _tex_macros = tex_macros
    if _tex_macros
      tex_macro_document =  NSDocument.create(title: 'Tex Macros', author_credentials: master.author_credentials2)
      tex_macro_document.content = "\\(" + _tex_macros + "\\)"
      DocumentRepository.update tex_macro_document
      AssociateDocManager.new(tex_macro_document).associate_to(master, 'texmacros')
    end

    # Set up a stack for iterating over lessons
    stack = []
    last_node = master
    count = 0

    # Process the lessons
    lessons.all.each do |lesson|
      count = count + 1
      puts "#{count}: #{lesson.id}, #{lesson.title}".cyan
      begin
        puts "A".red
        section = lesson.to_document(screen_name)
        puts "B".red
        stack == [] ?  delta = 2 : delta =  section.asciidoc_level - stack.last.asciidoc_level
        puts "C".red
        if delta >= 2
          stack.push(last_node)
        elsif delta <= 0
          stack.pop
        end
        puts "D".red
        section.add_to(stack.last)
        puts "E".red
        last_node = section
      rescue
        puts "Error in importing #{lesson.title} (#{lesson.id})".red
      end
    end

    return master
  end


  ### PRIVATE METHODS ###


  # Create an NSDocument from a Noteshare document
  def to_document(screen_name)
    user = UserRepository.find_one_by_screen_name(screen_name)
    return if user == nil

    doc = NSDocument.create(title: self.title, author_credentials: user.credentials)
    doc.author_id = user.id
    doc.author = user.full_name
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


  def titlepage_image

    data = self.course_attributes  || ''
    _match = data.match /^titlepage-image=(.*)$/
    if _match
      _match[1].to_i
    end

  end


end




