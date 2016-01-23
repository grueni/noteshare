require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class ShowAnalytics
    include Admin::Action

    expose :active_item, :doc_views_signed_in, :doc_views_anonymous, :edits,
           :sign_ins, :sign_outs, :sign_ups, :unauth_access_attempts
    def call(params)

      redirect_if_not_admin('Attempt to show analytics (admin, home, show analytics)')

      puts "Here is controller DisplayAnalytics".magenta
      @active_item = 'admin'

      document_view_count_signed_in = Analytics.get_keen_data(query_type: 'count', collection: 'document_views_signed_in')
      @doc_views_signed_in = "Document views, signed in: #{document_view_count_signed_in}"

      document_view_count_anonymous = Analytics.get_keen_data(query_type: 'count', collection: 'anonymous_document_views')
      @doc_views_anonymous = "Document views, anonymous: #{document_view_count_anonymous}"

      edits = Analytics.get_keen_data(query_type: 'count', collection: 'document_edit')
      @edits = "Edits: #{edits}"

      sign_ins_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ins')
      @sign_ins = "Sign ins: #{sign_ins_count}"

      sign_outs_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_outs')
      @sign_outs = "Sign outs: #{sign_outs_count}"

      sign_ups_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ups')
      @sign_ups = "Sign ups: #{sign_ups_count}"

      unauth_access_attempt_count = Analytics.get_keen_data(query_type: 'count', collection: 'unauthorized_access_attempt')
      @unauth_access_attempts = "Unauthorized access attempts: #{unauth_access_attempt_count}"
    end
  end
end
