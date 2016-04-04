module Editor::Controllers::Document
  class ExportLatex
    include Editor::Action


    def message(document)
      output = "<p style='margin:3em;'> <strong>#{document.title}</strong> exported as Asciidoc and LaTeX to "
      output << "<a href='http://vschool.s3.amazonaws.com/latex/#{document.id}.tar'>this link</a> "
      output << "<p style='margin:3em;'> The file to download from the link is #{document.id}.tar</p>"
      output << "</p>\n\n"
    end

    def call(params)
      id = params[:id]
      document = DocumentRepository.find id
      document = document.root_document
      redirect_to "/error:#{id}?Document not found" if document == nil
      e = Exporter.new(document)
      e.export_latex
      self.body = message(document)
    end
  end
end
