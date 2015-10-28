module Editor::Controllers::Document
  class Options
    include Editor::Action

     expose :document

    def call(params)
      puts ">> Editor options".red
      puts "PARAMS: #{params.inspect}".yellow
      puts "PARAM ID: #{params[:id]}".red
      @document = DocumentRepository.find params[:id]
      puts "DOC TITLE: #{@document.title}".cyan
      @document
    end
  end
end
