module Admin::Controllers::Course
  class Import
    include Admin::Action

    expose :active_item

    def call(params)
      @active_item = 'admin'
    end
  end
end
