module ImageManager::Controllers::Image
  class Update
    include ImageManager::Action
    expose :active_item

    def call(params)
      redirect_if_not_signed_in('editor, image,  Update')
      @active_item = 'images'
      puts "#{session[:current_image_id]}".magenta
      puts "#{params['source']}".cyan
      current_image = ImageRepository.find session[:current_image_id]
      puts "TITLE: #{current_image.title}".red

      current_image.title = params['title']
      current_image.tags = params['tags']
      current_image.source = params['source']
      ImageRepository.update current_image

      redirect_to "/image_manager/show/#{session[:current_image_id]}"
    end
  end
end
