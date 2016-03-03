module Editor::Controllers::Document
  class ExportLatex
    include Editor::Action

    def call(params)
      id = params[:id]
      document = DocumentRepository.find id
      redirect_to "/error:#{id}?Document not found" if document == nil
      e = Exporter.new(document)
      e.export_latex
      self.body = "#{document.title} exported as LaTeX to folder 'outgoing'"
    end
  end
end
