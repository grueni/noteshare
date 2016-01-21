module ImageManager::Controllers::Image
  class New
    include ImageManager::Action

    expose :active_item

    def call(params)
      redirect_if_not_signed_in('editor, image,  New')
      @active_item = 'images'
      puts "Image, new".red
    end
  end
end
