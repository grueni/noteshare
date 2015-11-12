

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document


    def call(params)
      puts "1".red
      @document = DocumentRepository.find(params['id'])
      puts "2".red
      session[:current_document_id] = @document.id
      @document.update_content
      puts "DOCUMENT TITLE: #{@document.title}".cyan
      puts "3".red
    end

  end
end
