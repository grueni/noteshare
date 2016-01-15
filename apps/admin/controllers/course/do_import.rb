module Admin::Controllers::Course
  class DoImport
    include Admin::Action

    def call(params)

      puts "Entering course importer".red

      course_id =params['course_import']['course_id']

      puts "course_id = #{course_id}".red

      course = CourseRepository.find course_id

      if course
        puts "COURSE TO IMPORT: #{course.title}".red

        screen_name = current_user(session).screen_name

        new_root_document = course.create_master_document(screen_name)

        redirect_to  "/titlepage/#{new_root_document.id}"
      else
         redirect_to "/error/#{course_id}?You tried to import a non-existent course."
      end



      # self.body = "Boss, I am importing #{course.title}"

    end

  end
end
