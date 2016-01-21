# apps/web/controllers/home/index.rb
module Editor::Controllers::Home
  class Index
    include Editor::Action

    def call(params)
      redirect_if_not_signed_in('editor, home, Index')
    end
  end
end