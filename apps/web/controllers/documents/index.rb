module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents

    def call(params)
      puts "XXXX: params = #{params}"
      @documents = DocumentRepository.root_documents
    end

  end
end
