module ImageManager::Controllers::Image
  class Show
    include ImageManager::Action

    expose :image, :active_item

    def call(params)
      redirect_if_not_signed_in('editor, image,  Show')
      @active_item = 'images'
      @image = ImageRepository.find params[:id]
      session[:current_image_id] = params[:id]
    end

  end
end
