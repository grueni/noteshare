module Editor::Controllers::Document
  class JsonUpdate
    include Editor::Action

    def call(params)
      puts ">> JSON UPDATE".red
      puts "source: #{params['source']}".cyan
      id = params['id'].to_i
      puts "ID:#{id}".red
      @document = DocumentRepository.find(id)
      @document.update_content params['source']
      puts "UPDATED CONTENT: #{@document.content}".blue
      @document.compile_with_render
      @document.synchronize_title
      DocumentRepository.update  @document
      puts "RENDERED CONTENT: #{@document.rendered_content}".cyan
      self.body = @document.rendered_content
    end

  end
end
