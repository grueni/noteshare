require_relative '../../../../lib/noteshare/interactors/editor/add_pdf'

module Editor::Controllers::Document
  class DoAddPdf
    include Editor::Action
    include Noteshare::Interactor::Document

    def call(params)

      result = AddPDF.new(params, current_user2).call
      Analytics.record_new_pdf_document(result.author, result.new_document)
      redirect_to "/editor/document/#{result.new_document.id}"

    end

  end
end
