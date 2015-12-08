module Web::Controllers::Documents
  class New
    include Web::Action
    expose :active_item

    def call(params)
      @active_item = 'reader'
    end
  end
end
