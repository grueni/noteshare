module Web::Controllers::Documents
  class SetSearchType
    include Web::Action

    def call(params)
      self.body = 'set search type -- OK'
    end
  end
end
