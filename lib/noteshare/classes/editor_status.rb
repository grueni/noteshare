
module Noteshare

  class EditorStatus

    def initialize(document)
      @document = document
      @dict = @document.dict
      if @dict['editors']
        @editors = @dict['editors'].split(',').map{ |x| x.strip }
      else
        @editors = []
      end
    end

    def editor_array_string_value
      @editors.join(', ')
    end

    def save
      @document.dict['editors'] = editor_array_string_value
      DocumentRepository.update @document
    end

    def add_editor(user)
      screen_name = user.screen_name
      if !@editors.include? screen_name
        @editors. << screen_name
      end
      save
    end

    def remove_editor(user)
      screen_name = user.screen_name
      if @editors.include? screen_name
        @editors.delete(screen_name)
      end
      save
    end


  end

end

