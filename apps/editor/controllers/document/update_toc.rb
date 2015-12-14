require "execjs"

module Editor::Controllers::Document
  class UpdateToc
    include Editor::Action

    def call(params)

      # permutation = ExecJS.eval "window.localStorage.getItem('toc_permutation')"

      permutation = ExecJS.eval "1 + 1"

      self.body = "PERMUTATION = #{permutation}"

    end

  end
end
