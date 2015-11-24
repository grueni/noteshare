module Editor::Controllers::Document
  class PrepareToDelete
    include Editor::Action

    expose :document

    def call(params)
      puts "controller: PrepareToDelete".red
      @document = DocumentRepository.find params[:id]
    end
  end
end
