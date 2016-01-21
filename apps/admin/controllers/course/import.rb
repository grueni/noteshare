module Admin::Controllers::Course
  class Import
    include Admin::Action

    expose :active_item

    def call(params)
      redirect_if_not_admin('Attempt to import course (admin, course, import)')
      @active_item = 'admin'
    end
  end
end
