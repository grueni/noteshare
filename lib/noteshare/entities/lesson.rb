class Lesson
  include Lotus::Entity
  attributes :id, :title, :content, :author_id, :course_id, :created_at, :modified_at,
             :tags, :area, :sequence, :summary, :aside, :image_path1, :image_path2, :content_type

  def handle_pdf(document)
    puts "ENTER: handle_pdf".magenta
    puts "image_path1 is #{self.image_path1}"
    document.dict['pdf:image_id'] = self.image_path1
    image = ImageRepository.find self.image_path1
    if image
      puts "image found: #{image.url2}".cyan
    else
      puts "image not found".red
    end
    return if image == nil
    puts "image in is not nil, proceeding".cyan
    document.dict['pdf:url'] = image.url2
    puts "dict has been updated: #{document.dict}".green
    puts "document content = #{document.content}".red
    document.content = self.content || ''
    puts "A".red
    document.content << "\n\n#{image.url2}[PDF document]\n\n"
    puts "B".red
    document.content << "++++\n"
    document.content << "<iframe src='#{image.url2}' width=100% height=1200 ></iframe>\n"
    puts "C".red
    document.content << "++++\n"
    puts "content has been updated".red
  end

  def handle_pdf1(document)
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

    handle_pdf(doc) if self.content_type == 'pdf'
    puts "I have returned from handle_pdf".magenta  if self.content_type == 'pdf'

    DocumentRepository.update(doc)
    puts "   --- doc content length: #{doc.content.length}".magenta
    return doc
  end

end

