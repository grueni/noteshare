require_relative '../../../../lib/modules/analytics'

module Admin::Controllers::Home
  class ShowAnalytics
    include Admin::Action

    expose :active_item,
           :doc_views_signed_in, :doc_views_signed_in_daily_average,
           :doc_views_anonymous, :doc_views_anonymous_daily_average,
           :edits, :edits_daily_average,
           :new_sections, :new_sections_daily_average,
           :new_pdf_document, :new_pdf_document_daily_average,
           :image_upload, :image_upload_daily_average,
           :sign_ins, :sign_ins_daily_average,
           :sign_outs, :sign_outs_daily_average,
           :sign_ups, :sign_ups_daily_average,
           :unauth_access_attempts, :unauth_access_attempts_daily_average



    def daily_average(count)
      c = count.to_i
      (c/7.0).round(1)
    end

    def call(params)

      redirect_if_not_admin('Attempt to show analytics (admin, home, show analytics)')

      @active_item = 'admin'

      document_view_count_signed_in = Analytics.get_keen_data(query_type: 'count', collection: 'document_views_signed_in')
      @doc_views_signed_in = "#{document_view_count_signed_in}"
      @doc_views_signed_in_daily_average = "#{daily_average(document_view_count_signed_in)}"

      document_view_count_anonymous = Analytics.get_keen_data(query_type: 'count', collection: 'anonymous_document_views')
      @doc_views_anonymous = "#{document_view_count_anonymous}"
      @doc_views_anonymous_daily_average = "#{daily_average(document_view_count_anonymous)}"

      edits = Analytics.get_keen_data(query_type: 'count', collection: 'document_edit')
      @edits = "#{edits}"
      @edits_daily_average = "#{daily_average(edits)}"

      new_sections = Analytics.get_keen_data(query_type: 'count', collection: 'new_section')
      @new_sections = "#{new_sections}"
      @new_sections_daily_average = "#{daily_average(new_sections)}"

      new_pdf_document = Analytics.get_keen_data(query_type: 'count', collection: 'new_pdf_document')
      @new_pdf_document = "#{new_pdf_document}"
      @new_pdf_document_daily_average = "#{daily_average(new_pdf_document)}"

      image_upload = Analytics.get_keen_data(query_type: 'count', collection: 'image_upload')
      @image_upload = "#{image_upload}"
      @image_upload_daily_average = "#{daily_average(image_upload)}"

      sign_ins_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ins')
      @sign_ins = "#{sign_ins_count}"
      @sign_ins_daily_average = "#{daily_average(sign_ins_count)}"

      sign_outs_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_outs')
      @sign_outs = "#{sign_outs_count}"
      @sign_outs_daily_average = "#{daily_average(sign_outs_count)}"

      sign_ups_count = Analytics.get_keen_data(query_type: 'count', collection: 'sign_ups')
      @sign_ups = "#{sign_ups_count}"
      @sign_ups_daily_average = "#{daily_average(sign_ups_count)}"

      unauth_access_attempt_count = Analytics.get_keen_data(query_type: 'count', collection: 'unauthorized_access_attempt')
      @unauth_access_attempts = "#{unauth_access_attempt_count}"
      @unauth_access_attempts_daily_average = "#{daily_average(unauth_access_attempt_count)}"
    end
  end
end
