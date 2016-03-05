require_relative '../../../../lib/modules/analytics'

module Web::Controllers::Documents
  class Titlepage
    include Web::Action
    include Analytics

    expose :root_document, :document, :toc, :blurb, :image_url,  :view_options
    expose :active_item, :active_item2

    def call(params)

      @view_options =  {stem: 'titlepage'}

      puts "controller: Titlepage".red

      @active_item = 'reader'
      @active_item2 = 'titlepage'

      @document = DocumentRepository.find(params['id'])
      handle_nil_document(@document, params['id'])
      redirect_if_document_not_public(@document, 'Unauthorized attempt to read document that is not world-readable')

      session[:current_document_id] = @document.id

      @root_document = @document.root_document
      cm = ContentManager.new(@root_document, {numbered: true, format: 'adoc-latex'})
      cm.compile_with_render
      @root_document.compiled_content = ContentManager.new(@root_document).compile

      session[:current_document_id] = @root_document.id
      puts "web titlepage, recording session[:current_document_id] as #{session[:current_document_id]}".red

      remember_user_view('titlepage', session)
      cu = current_user(session)
      ActivityManager.new(@document, cu).record
      Analytics.record_document_view(cu, @root_document)

      @blurb = @root_document.dict['blurb'] || 'blurb'

      titlepage_image_id =  @root_document.dict['titlepage_image'] || 727
      titlepage_image = ImageRepository.find  titlepage_image_id
      @image_url = titlepage_image.url2


    end
  end
end
