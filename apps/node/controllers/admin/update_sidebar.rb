module Node::Controllers::Admin
  class UpdateSidebar
    include Node::Action

    def call(params)
      data = params['node']

      sidebar_text = data['sidebar_text'] || ''

      id = params['id']
      node = NSNode.find id

      node.meta['sidebar_text'] = sidebar_text
      node.update_sidebar_text

      redirect_to basic_link current_user2.screen_name, "node/#{id}"

      self.body = "OK Boss, I am updating the blurb, just as you say.: #{blurb_text}"
    end
  end
end
