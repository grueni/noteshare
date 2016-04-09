require_relative '../../../../lib/noteshare/interactors/editor/read_document'

module Web::Controllers::Documents
  class Titlepage
    include Web::Action
    include Analytics

    expose :root_document, :document, :payload, :blurb, :image_url,  :view_options
    expose :active_item, :active_item2

    def call(params)

      @view_options =  {stem: 'titlepage'}
      @active_item = 'reader'
      @active_item2 = 'titlepage'

      @payload = ReadDocument.new(params, current_user2, 'titlepage').call
      redirect_to_path @payload.redirect_path

      handle_error(@payload.error)
      @document = @payload.document
      @root_document = @payload.root_document

      session[:current_document_id] = @document.id

      session[:current_document_id] = @root_document.id
      remember_user_view('titlepage', session)

      @blurb = @root_document.dict['blurb'] || 'blurb'

      titlepage_image_id =  @root_document.dict['titlepage_image'] || 727
      titlepage_image = ImageRepository.find  titlepage_image_id
      @image_url = titlepage_image.url2


    end
  end
end
