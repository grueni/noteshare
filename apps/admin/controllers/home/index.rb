# apps/web/controllers/home/index.rb
require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class Index
    include Admin::Action
    include Analytics

    expose :active_item, :page_views

    def call(params)
      @active_item = 'admin'
      @page_views = Analytics.get_keen_data(query_type: 'count', collection: 'page_views')
    end

  end
end
