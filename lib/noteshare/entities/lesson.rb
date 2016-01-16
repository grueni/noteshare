class Lesson
  include Lotus::Entity
  attributes :id, :title, :content, :author_id, :course_id, :created_at, :modified_at,
             :tags, :area, :sequence, :summary, :aside, :image_path1, :image_path2, :content_type

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
=begin
    if doc.content_type == 'pdf'
      doc.dict['pdf:image_id'] = self.image_path1
      doc.dict['pdf:url'] = (Image.find self.image_path1).url2
      content << "\n\n#{dict['pdf:url']}[PDF document]\n\n"
      content << "++++\n"
      content << "<iframe src='#{dict['pdf:url']}' width=100% height=1200 ></iframe>\n"
      content << "++++\n"
    end
=end
    DocumentRepository.update(doc) if !doc.id
    puts "   --- doc content length: #{doc.content.length}".magenta
    return doc
  end

end

