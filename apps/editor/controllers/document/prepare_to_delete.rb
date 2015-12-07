module Editor::Controllers::Document
  class PrepareToDelete
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      puts "controller: PrepareToDelete".red
      @document = DocumentRepository.find params[:id]
    end
  end
end
