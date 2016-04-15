module Viewer::Controllers::Document
  class Print
    include Viewer::Action

    expose :document, :active_item


    def call(params)

      redirect_if_not_signed_in('viewer, Document,  Print')

      option = request.query_string
      id = params['id']

      self.body = Noteshare::Interactor::Document::PrintManager.new(id, option).call

    end
  end
end
