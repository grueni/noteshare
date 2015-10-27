module Web::Controllers::Documents
  class Index
    include Web::Action

    expose :documents

    def call(params)
      @documents = DocumentRepository.all
    end

  end
end
