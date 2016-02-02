module Web::Controllers::Documents
  class New
    include Web::Action
    expose :active_item

    def call(params)
      @active_item = 'reader'
      redirect_if_not_signed_in('editor, document, Options')
    end
  end
end
