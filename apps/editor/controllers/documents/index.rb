module Editor::Controllers::Documents
  class Index
    include Editor::Action

    expose :documents

    def call(params)
      redirect_if_not_signed_in('editor, documents, Index')
      puts "XX, Index: params = #{params}"
      @documents = DocumentRepository.all
    end

  end
end
