module ImageManager::Controllers::Image
  class Show
    include ImageManager::Action

    expose :image

    def call(params)
      @image = ImageRepository.find params[:id]
    end

  end
end
