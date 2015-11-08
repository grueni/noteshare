module ImageManager::Controllers::Image
  class New
    include ImageManager::Action

    def call(params)
      puts "Image, new".red
    end
  end
end
