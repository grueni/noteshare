module Editor::Controllers::Document
  class JsonUpdate
    include Editor::Action

    def call(params)
      puts ">> JSON UPDATE".red
      id = params['id'].to_i
      @document = DocumentRepository.find(id)
      @document.update_content params['source']
      @document.compile_with_render
      @document.synchronize_title
      self.body = @document.rendered_content
    end

  end
end
