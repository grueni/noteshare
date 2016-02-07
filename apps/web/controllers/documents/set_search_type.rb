module Web::Controllers::Documents
  class SetSearchType
    include Web::Action

    def call(params)
      self.body = 'set searsch type -- OK'
    end
  end
end
