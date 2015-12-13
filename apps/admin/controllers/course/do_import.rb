module Admin::Controllers::Course
  class DoImport
    include Admin::Action

    def call(params)

      puts "Entering course importer".red

      course_id =params['course_import']['course_id']

      puts "course_id = #{course_id}".red

      course = CourseRepository.find course_id

      puts "COURSE TO IMPORT: #{course.title}".red

      screen_name = current_user(session).screen_name

      course.create_master_document(screen_name)

      self.body = "Boss, I am importing #{course.title}"

    end

  end
end
