module Node::Controllers::Admin
  class EditBlurb
    include Node::Action

    expose :active_item, :node

    def call(params)
      puts "Edit blurb call".red
      redirect_if_not_signed_in('image, Admin,  Edit')
      @active_item='admin'
      id = params['id']
      @node = NSNodeRepository.find(id)
      #fixme:

      if @node.meta == nil
        @node.meta = {}
        NSNodeRepository.update @node
      end

    end
  end
end
