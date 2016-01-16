class Lesson
  include Lotus::Entity
  attributes :id, :title, :content, :author_id, :course_id, :created_at, :modified_at,
             :tags, :area, :sequence, :summary, :aside, :image_path1, :image_path2, :content_type

  def handle_pdf1(document)
    document.dict['pdf:image_id'] = self.image_path1
    document.dict['pdf:url'] = (Image.find self.image_path1).url2
    document.content ||= ''
    document.content << "\n\n#{dict['pdf:url']}[PDF document]\n\n"
    document.content << "++++\n"
    document.content << "<iframe src='#{dict['pdf:url']}' width=100% height=1200 ></iframe>\n"
    document.content << "++++\n"
  end

  def handle_pdf(document)
    puts "HAS PDF: #{document.title}"
  end

  def to_document(screen_name)
    puts "In to_document for #{self.title} (#{self.id})".red
    user = UserRepository.find_one_by_screen_name(screen_name)
    return if user == nil
    doc = NSDocument.create(title: self.title, author_credentials: user.credentials)
    doc.author_id = self.author_id
    doc.tags = self.tags
    doc.area = self.area
    doc.created_at = self.created_at
    doc.modified_at =  self.modified_at
    doc.content = self.content

    # handle_pdf(doc) if doc.content_type == 'pdf'


    DocumentRepository.update(doc) if !doc.id
    puts "   --- doc content length: #{doc.content.length}".magenta
    return doc
  end

end

