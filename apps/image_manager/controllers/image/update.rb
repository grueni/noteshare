module ImageManager::Controllers::Image
  class Update
    include ImageManager::Action
    expose :active_item

    def call(params)
      redirect_if_not_signed_in('editor, image,  Update')
      puts "Controller image, update -- I HAVE BEEN CALLED"
      puts "In Controller image, update, session = #{session.inspect}".cyan
      payload = params['edit_image']
      id = params['id']
      puts "In Controller image, update, ID = #{id}"
      session[:current_image_id] = id
      puts "XXXX: In Controller image, update, session = #{session.inspect}".cyan
      @active_item = 'images'
      if session[:current_image_id]
        puts "#{session[:current_image_id]}".magenta
      else
        puts 'session[:current_image_id] = NIL'.magenta
      end
      current_image = ImageRepository.find id
      current_image.title = payload['title']
      current_image.tags = payload['tags']
      current_image.source = payload['source']
      ImageRepository.update current_image

      redirect_to "/image_manager/search?current_image_id=#{id}"
    end
  end
end
