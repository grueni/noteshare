module Viewer::Controllers::Document
  class Print
    include Viewer::Action

    expose :document, :active_item


    def call(params)

      redirect_if_not_signed_in('viewer, Document,  Print')

      option = request.query_string
      id = params['id']

      puts "OPTION: #{option}".red
      result = Noteshare::Interactor::Document::PrintManager.new(document_id: id, option: option).call
      self.body = result.html

    end
  end
end
