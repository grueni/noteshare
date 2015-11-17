module ImageManager::Controllers::Image
  class List
    include ImageManager::Action

    expose :images

    def call(paramm)

      @images = ImageRepository.all

    end

  end
end
