# apps/web/controllers/home/index.rb
require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class Index
    include Admin::Action
    include Analytics

    expose :active_item, :analytics

    def call(params)
      @active_item = 'admin'
      page_view_count = Analytics.get_keen_data(query_type: 'count', collection: 'page_views')
      page_view_average = Analytics.get_keen_data(query_type: 'average', collection: 'page_views')
      @analytics = "Page views: #{page_view_count}, average: #{page_view_average}"
    end

  end
end
