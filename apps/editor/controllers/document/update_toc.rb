

module Editor::Controllers::Document
  class UpdateToc
    include Editor::Action

    def call(params)


      puts "controller, UpdateToc".red
      puts request.query_string.cyan
      self.body = "PERMUTATION = ???"

    end

    #Fixme: we really shouldn't do this
    private
    def verify_csrf_token?
      false
    end


  end
end
