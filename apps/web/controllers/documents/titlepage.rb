require_relative '../../../../lib/noteshare/interactors/editor/read_document'

module Web::Controllers::Documents
  class Titlepage
    include Web::Action
    include Analytics

    expose :root_document, :document, :toc, :blurb, :image_url,  :view_options
    expose :active_item, :active_item2

    def call(params)

      @view_options =  {stem: 'titlepage'}
      @active_item = 'reader'
      @active_item2 = 'titlepage'

      result = ReadDocument.new(params, current_user2).call
      handle_error(result.error)
      @document = result.document
      @root_document = result.root_document

      session[:current_document_id] = @document.id

      cm = ContentManager.new(@root_document, {numbered: true, format: 'adoc-latex'})
      cm.compile_with_render
      @root_document.compiled_content = ContentManager.new(@root_document).compile

      session[:current_document_id] = @root_document.id
      remember_user_view('titlepage', session)

      @blurb = @root_document.dict['blurb'] || 'blurb'

      titlepage_image_id =  @root_document.dict['titlepage_image'] || 727
      titlepage_image = ImageRepository.find  titlepage_image_id
      @image_url = titlepage_image.url2


    end
  end
end
