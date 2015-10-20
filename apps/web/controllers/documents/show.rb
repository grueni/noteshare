

module Web::Controllers::Documents
  class Show
    include Web::Action

    expose :document

    def call(params)
      puts "XXXX: params = #{params[:id]}"
      @document = DocumentRepository.find(params['id'])
    end

  end
end
