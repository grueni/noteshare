class CourseRepository
  include Lotus::Repository

  def self.by_title(key, limit: 8)
    array = fetch("SELECT id FROM courses WHERE title ILIKE '%#{key}%';")
    array = array.map{ |h| h[:id] }.uniq
    array.map{ |id| CourseRepository.find id }.sort_by { |item| item.title }
  end


end
