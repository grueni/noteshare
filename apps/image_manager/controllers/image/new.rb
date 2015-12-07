module ImageManager::Controllers::Image
  class New
    include ImageManager::Action

    expose :active_item

    def call(params)
      @active_item = 'images'
      puts "Image, new".red
    end
  end
end
