module Admin::Views::Course
  class Import
    include Admin::View

    def form
      puts ">> form Import course".red

      form_for :course_import, '/admin/course/do_import', class: '' do

        label :course_id
        text_field :course_id

        label :screen_name
        text_field :screen_name

        submit 'Import course',  class: "waves-effect waves-light btn"

      end
    end
  end
end
