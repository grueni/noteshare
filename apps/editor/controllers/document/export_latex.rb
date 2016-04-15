module Editor::Controllers::Document
  class ExportLatex
    include Editor::Action

    def call(params)

      result = Noteshare::Interactor::Document::Exporter.new(params).call
      if result.redirect_path
        redirect_to result.redirect_path
      else
        self.body = result.message
      end

    end
  end
end
