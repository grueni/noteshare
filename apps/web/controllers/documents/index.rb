 module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents

    def call(params)
      @documents = DocumentRepository.root_documents.sort_by { |item| item.title }
      puts "ROOT DOCUMENTS: #{@documents.count}".red
    end

  end
end
