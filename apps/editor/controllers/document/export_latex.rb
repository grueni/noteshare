module Editor::Controllers::Document
  class ExportLatex
    include Editor::Action

    def call(params)
      id = params[:id]
      document = DocumentRepository.find id
      redirect_to "/error:#{id}?Document not found" if document == nil
      e = Exporter.new(document)
      e.export_latex
      output = "<p style='margin:3em;'> <strong>#{document.title}</strong> exported as Asciidoc and LaTeX to "
      output << "<a href='http://vschool.s3.amazonaws.com/latex/#{document.id}.tar'>this link</a> "
      output << "</p>\n\n"
      self.body = output
    end
  end
end
