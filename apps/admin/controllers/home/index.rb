# apps/web/controllers/home/index.rb
require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class Index
    include Admin::Action
    include Analytics

    expose :active_item

    def call(params)
      @active_item = 'admin'
    end

  end
end
