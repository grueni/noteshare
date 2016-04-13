module Admin::Controllers::Course
  class Find
    include Admin::Action
    include OldNoteshare

    expose :courses, :active_item

    def call(params)
      @active_item = 'admin'
      @courses = CourseRepository.all.select{ |c| c.title != 'My Notebook' }.sort_by{ |c| c.title }
    end
  end
end
