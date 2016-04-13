module Editor::Controllers::Document

  include Noteshare::Core::Document

  # This code is called restfully by Javascript,
  # ajaxs $.post. See javascripts/editor.js
  class JsonUpdate
    include Editor::Action

    expose :active_item

    def call(params)
      id = request.env['REQUEST_URI'].split('/')[-1]
      @active_item = 'editor'
      @document = DocumentRepository.find(id)
      @document.content_dirty = true
      ContentManager.new(@document).update_content params['source']
      @document.synchronize_title unless @document.dict['synchronize_title'] == 'no'
      self.body = @document.rendered_content
    end


  end
end

