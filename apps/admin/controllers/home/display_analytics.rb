require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class DisplayAnalytics
    include Admin::Action

    expose :active_item, :analytics_pages_signed_in, :analytics_pages_anonymous,
           :analytics_sign_ins, :analytics_sign_outs, :analytics_sign_ups

    def call(params)
      redirect_if_not_admin('Attempt to display analytics (admin, home, diplay analytics)')

      puts "Here is controller DisplayAnalytics".magenta
      @active_item = 'admin'

      page_view_count_signed_in = DisplayAnalytics.get_keen_data(query_type: 'count', collection: 'page_views_signed_in')
      page_view_average_signed_in = DisplayAnalytics.get_keen_data(query_type: 'average', collection: 'page_views_signed_in')
      @analytics_pages_signed_in = "Page views, signed in: #{page_view_count_signed_in}, average: #{page_view_average_signed_in}"

      page_view_count_anonymous = DisplayAnalytics.get_keen_data(query_type: 'count', collection: 'page_views_anonymous')
      page_view_average_anonymous = DisplayAnalytics.get_keen_data(query_type: 'average', collection: 'page_views_anonymous')
      @analytics_pages_anonymous = "Page views, anonymous: #{page_view_count_anonymous}, average: #{page_view_average_anonymous}"

      sign_ins_count = DisplayAnalytics.get_keen_data(query_type: 'count', collection: 'sign_ins')
      sign_ins_average = DisplayAnalytics.get_keen_data(query_type: 'average', collection: 'sign_ins')
      @analytics_sign_ins = "Sign ins: #{sign_ins_count}, average: #{sign_ins_average}"

      sign_outs_count = DisplayAnalytics.get_keen_data(query_type: 'count', collection: 'sign_outs')
      sign_outs_average = DisplayAnalytics.get_keen_data(query_type: 'average', collection: 'sign_outs')
      @analytics_sign_outs = "Sign outs: #{sign_outs_count}, average: #{sign_outs_average}"

      sign_ups_count = DisplayAnalytics.get_keen_data(query_type: 'count', collection: 'sign_ups')
      sign_ups_average = DisplayAnalytics.get_keen_data(query_type: 'average', collection: 'sign_ups')
      @analytics_sign_ups = "Sign ups: #{sign_ups_count}, average: #{sign_ups_average}"
    end
  end
end
