# apps/web/controllers/home/index.rb
module Admin::Controllers::Home
  class Index
    include Admin::Action

    expose :active_item

    def call(params)
      @active_item = 'admin'
    end

  end
end
