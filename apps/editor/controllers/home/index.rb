# apps/web/controllers/home/index.rb
module Editor::Controllers::Home
  class Index
    include Editor::Action

    def call(params)
      self.body = 'OK'
    end
  end
end