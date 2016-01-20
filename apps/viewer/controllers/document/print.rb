module Viewer::Controllers::Document
  class Print
    include Viewer::Action

    expose :document, :active_item


    def call(params)

      id = params['id']
      @document = DocumentRepository.find  id
      if @document == nil
        redirect_to "/error/#{id}?Couldn't find the document you want to print"
      end

      pm = PrintManager.new(@document)
      pm.process_document
      html = pm.get_print_string

      self.body = html

    end
  end
end
