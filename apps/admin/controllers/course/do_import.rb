module Admin::Controllers::Course
  class DoImport
    include Admin::Action

    def call(params)

      puts "Entering course importer".red

      course_id = params['course_import']['course_id']
      screen_name = params['course_import']['screen_name']

      puts "course_id = #{course_id}".red

      course = CourseRepository.find course_id
      if course == nil
        redirect_to "/error/#{course_id}?You tried to import a non-existent course."
      end

      user = UserRepository.find_by_screen_name screen_name
      if user == nil
        redirect_to "/error/#{course_id}?Screen name is invalid."
      end

      new_root_document = course.create_master_document(screen_name)
      redirect_to  "/titlepage/#{new_root_document.id}"

    end

  end
end
