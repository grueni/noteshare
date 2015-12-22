module Editor::Controllers::Document
  class Options
    include Editor::Action

     expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      puts "controller Editor Options".red
      @document = DocumentRepository.find params[:id]
    end
  end
end
