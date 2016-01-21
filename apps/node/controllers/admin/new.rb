module Node::Controllers::Admin
  class New
    include Node::Action

    expose :active_item

    def call(params)
      redirect_if_not_signed_in('image, Admin,  New')
      @active_item = 'admin'
    end
  end
end
