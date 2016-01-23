require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class ShowAnalytics
    include Admin::Action

    expose :active_item, :doc_views_signed_in, :doc_views_anonymous, :edits, :new_sections, :new_pdf_document,
           :sign_ins, :sign_outs, :sign_ups, :unauth_access_attempts


    def daily_average(count)
      c = count.to_i
      (c/7.0).round(1)
    end

    def call(params)

      redirect_if_not_admin('Attempt to show analytics (admin, home, show analytics)')

      puts "Here is controller DisplayAnalytics".magenta
      @active_item = 'admin'

      document_view_count_signed_in = Analytics.get_keen_data(query_type: 'count', collection: 'document_views_signed_in')
      @doc_views_signed_in = "Document views, signed in: #{document_view_count_signed_in}  — #{daily_average(document_view_count_signed_in)}"

      document_view_count_anonymous = Analytics.get_keen_data(query_type: 'count', collection: 'anonymous_document_views')
      @doc_views_anonymous = "Document views, anonymous: #{document_view_count_anonymous}  — #{daily_average(document_view_count_anonymous)}"

      edits = Analytics.get_keen_data(query_type: 'count', collection: 'document_edit')
      @edits = "Edits: #{edits}  — #{daily_average(edits)}"

      new_sections = Analytics.get_keen_data(query_type: 'count', collection: 'new_section')
      @new_sections = "New documents: #{new_sections}  — #{daily_average(new_sections)}"

      new_pdf_document = Analytics.get_keen_data(query_type: 'count', collection: 'new_pdf_document')
      @new_pdf_document = "New pdf file: #{new_pdf_document}  — #{daily_average(new_pdf_document)}"

      sign_ins_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ins')
      @sign_ins = "Sign ins: #{sign_ins_count} — #{daily_average(sign_ins_count)}"

      sign_outs_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_outs')
      @sign_outs = "Sign outs: #{sign_outs_count} — #{daily_average(sign_outs_count)}"

      sign_ups_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ups')
      @sign_ups = "Sign ups: #{sign_ups_count}  — #{daily_average(sign_ups_count)}"

      unauth_access_attempt_count = Analytics.get_keen_data(query_type: 'count', collection: 'unauthorized_access_attempt')
      @unauth_access_attempts = "Unauthorized access attempts: #{unauth_access_attempt_count}  — #{daily_average(unauth_access_attempt_count)}"
    end
  end
end
