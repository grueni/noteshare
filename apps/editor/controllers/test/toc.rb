module Editor::Controllers::Test
  class Toc
    include Editor::Action

    def call(params)

      puts "controller Test Toc".red

    end
  end
end
