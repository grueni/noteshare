module Editor::Controllers::Document
  class CreateNewSection
    include Editor::Action

    def call(params)
      self.body = 'OK'
    end
  end
end
