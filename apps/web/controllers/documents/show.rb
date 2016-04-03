
require 'keen'
require_relative '../../../../lib/noteshare/interactors/editor/read_document'

module Web::Controllers::Documents
  class Show
    include Web::Action
    include Keen

    expose :document, :root_document,  :active_item, :active_item2,  :view_options

    def call(params)
      puts "Boss this is Docuemnts, Show".red
      @active_item = 'reader'
      @active_item2 = 'standard'
      @view_options =  {stem: 'document'}

      result = ReadDocument.new(params, current_user2).call
      handle_error(result.error)
      @document = result.document
      @root_document = result.root_document

      session[:current_document_id] = @document.id
      remember_user_view('standard', session)

      query_string = request.query_string || ''
      if query_string != ''
        redirect_to "/document/#{document_id}\##{query_string}"
      end
    end
  end
end
