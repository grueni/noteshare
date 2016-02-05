module Node::Controllers::Admin
  class EditBlurb
    include Node::Action

    expose :active_item, :node

    def call(params)
      redirect_if_not_signed_in('image, Admin,  Edit')
      @active_item='admin'
      id = params['id']
      @node = NSNodeRepository.find(id)


    end
  end
end
