module Editor::Controllers::Document
  class EditorStatus
    include Editor::Action

    def call(params)
      self.body = 'OK'
    end
  end
end
