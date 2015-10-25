# apps/web/controllers/books/create.rb
module Editor::Controllers::Documents
  class Create
    include Editor::Action

    expose :document

    def call(params)

      puts "CCCC: params[:id] = #{params[:id]}"
      puts "CCCC: params[:parent_id] = #{params[:parent_id]}"

      @document = DocumentRepository.create(NSDocument.new(params[:document]))
      @document.content ||= ''
      @document.update_content
      @document.compile_with_render

      if @document.parent_id
        @parent_doc = DocumentRepository.find @document.parent_id
        @document.add_to(@parent_doc)
        @parent_doc.update_table_of_contents
      end

      DocumentRepository.update @document

      redirect_to '/documents'
    end
  end
end