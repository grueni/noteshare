class LessonRepository
  include Lotus::Repository

  def self.select_for_course(id)
    query do
      where(course_id: id)
          order(:sequence)
    end
  end

  def self.sections_of_course(id)
    sections = self.select_for_course(id)
    output = ''
    sections.all.each do |s|
      output << "#{s.sequence}, #{s.id}: #{s.title}\n"
    end
    output
  end


end
