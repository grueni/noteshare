 module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents
    expose :active_item

    def call(params)

      # @documents = DocumentRepository.root_documents.sort_by { |item| item.title }
      @documents = DocumentRepository.all
      @active_item = 'home'
      puts "COUNT: #{@documents.count}".magenta
      puts "ROOT DOCUMENTS: #{@documents.count}".red
    end

  end
end
