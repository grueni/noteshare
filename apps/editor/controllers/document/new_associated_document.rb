module Editor::Controllers::Document
  class NewAssociatedDocument
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      puts 'controller: NewAssociatedDocument'.red
      @document = DocumentRepository.find params['id']

      if @document == nil
        redirect_to "/error/#{params['id']}?No document found (weird)!"
      end

      puts "In controller, NewAssociatedDocument, document = #{@document.title}".red

    end

  end
end
