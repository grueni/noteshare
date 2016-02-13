module Web::Controllers::Documents
  class SetSearchType
    include Web::Action

    def call(params)
      puts "controller Documents, SetSearchType".red
      self.body = 'set search type -- OK'
    end

  end
end
