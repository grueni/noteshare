

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document


    def call(params)
      puts "XXXX: params = #{params[:id]}"
      puts "SERVER: #{request.env['SERVER_NAME']}"
      puts "PORT: #{request.env['SERVER_PORT']}"
      @document = DocumentRepository.find(params['id'])
      @document.update_content
      # @document.compile_with_render
    end

  end
end
