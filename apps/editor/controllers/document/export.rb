module Editor::Controllers::Document
  class Export
    include Editor::Action

    # expose :document

    def call(params)
=begin
      puts "EXPORT: params[:id] = #{params[:id]}"
      @document = DocumentRepository.find(params['id'])
      hash = { export: 'yes' }
      @document.compile_with_render(hash)
=end
    end

    # redirect_to "/"
    # redirect_to "document/#{params[:id]}"
  end
end
