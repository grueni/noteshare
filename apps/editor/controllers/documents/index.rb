module Editor::Controllers::Documents
  class Index
    include Editor::Action

    expose :documents

    def call(params)
      puts "XX, Index: params = #{params}"
      @documents = DocumentRepository.all
    end

  end
end
