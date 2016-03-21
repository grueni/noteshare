module Node::Controllers::Admin
  class UpdateBlurb
    include Node::Action

    def call(params)

      data = params['node']

      puts "data: #{data.inspect}".red
      blurb_text = data['blurb'] || ''

      puts "blurb_text: #{blurb_text}".cyan

      id = params['id']
      node = NSNodeRepository.find id

      # @renderer = Render.new(blurb_text)
      # node.meta['rendered_blurb'] = @renderer.convert
      # node.meta['long_blurb'] = blurb_text
      node.update_blurb

      NSNodeRepository.update node

      redirect_to basic_link current_user2.screen_name, "node/#{id}"

      self.body = "OK Boss, I am updating the blurb, just as you say.: #{blurb_text}"
    end
  end
end
