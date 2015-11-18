module ImageManager::Controllers::Image
  class Show
    include ImageManager::Action

    expose :image

    def call(params)
      @image = ImageRepository.find params[:id]
      session[:current_image_id] = params[:id]
    end

  end
end
