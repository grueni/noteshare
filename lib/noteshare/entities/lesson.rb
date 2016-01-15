class Lesson
  include Lotus::Entity
  attributes :id, :title, :content, :author_id, :course_id, :created_at, :modified_at,
             :tags, :area, :sequence, :summary, :aside, :image_path1, :image_path2

  def to_document(screen_name)
    puts "In to_document for #{self.title} (#{self.id})".red
    puts "td1".cyan
    user = UserRepository.find_one_by_screen_name(screen_name)
    puts "td2".cyan
    return if user == nil
    puts "td3".cyan
    doc = NSDocument.create(title: self.title, author_credentials: user.credentials)
    puts "td4".cyan
    doc.author_id = self.author_id
    doc.tags = self.tags
    doc.area = self.area
    doc.created_at = self.created_at
    doc.modified_at =  self.modified_at
    doc.content = self.content
    puts "td5".cyan
    DocumentRepository.update(doc) if !doc.id
    puts "td5".cyan
    return doc
  end

end

