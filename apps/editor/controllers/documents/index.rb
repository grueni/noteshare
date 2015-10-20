module Editor::Controllers::Documents
  class Index
    include Editor::Action

    expose :documents

    def call(params)
      puts "XXXX: params = #{params}"
      @documents = DocumentRepository.all
    end

  end
end
