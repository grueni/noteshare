module Editor::Controllers::Test
  class Toc
    include Editor::Action

    def call(params)
      redirect_if_not_signed_in('editor, test, Toc')
      puts "controller Test Toc".red

    end
  end
end
