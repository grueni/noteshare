module Node::Controllers::Admin
  class UpdateBlurb
    include Node::Action

    def call(params)

      data = params['node']
      blurb_text = data['blurb']
      id = params['id']
      node = NSNodeRepository.find id
      node.meta['long_blurb'] = blurb_text
      NSNodeRepository.update node

      redirect_to basic_link current_user(session).screen_name, "node/#{id}"

      self.body = "OK Boss, I am updating the blurb, just as you say.: #{blurb_text}"
    end
  end
end
