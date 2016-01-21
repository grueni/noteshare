require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class ShowAnalytics
    include Admin::Action

    expose :active_item, :analytics_pages_signed_in, :analytics_pages_anonymous,
           :analytics_sign_ins, :analytics_sign_outs, :analytics_sign_ups

    def call(params)

      redirect_if_not_admin('Attempt to show analytics (admin, home, show analytics)')

      puts "Here is controller DisplayAnalytics".magenta
      @active_item = 'admin'

      page_view_count_signed_in = Analytics.get_keen_data(query_type: 'count', collection: 'document_views_signed_in')
      page_view_average_signed_in = Analytics.get_keen_data(query_type: 'average', collection: 'document_views_signed_in')
      @analytics_pages_signed_in = "Page views, signed in: #{page_view_count_signed_in}, average: #{page_view_average_signed_in}"

      page_view_count_anonymous = Analytics.get_keen_data(query_type: 'count', collection: 'anonymous_document_views')
      anonymous_document_views = Analytics.get_keen_data(query_type: 'average', collection: 'anonymous_document_views')
      @analytics_pages_anonymous = "Page views, anonymous: #{page_view_count_anonymous}, average: #{anonymous_document_views}"

      sign_ins_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ins')
      sign_ins_average = Analytics.get_keen_data(query_type: 'average', collection: 'sign_ins')
      @analytics_sign_ins = "Sign ins: #{sign_ins_count}, average: #{sign_ins_average}"

      sign_outs_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_outs')
      sign_outs_average = Analytics.get_keen_data(query_type: 'average', collection: 'sign_outs')
      @analytics_sign_outs = "Sign outs: #{sign_outs_count}, average: #{sign_outs_average}"

      sign_ups_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ups')
      sign_ups_average = Analytics.get_keen_data(query_type: 'average', collection: 'sign_ups')
      @analytics_sign_ups = "Sign ups: #{sign_ups_count}, average: #{sign_ups_average}"
    end
  end
end
