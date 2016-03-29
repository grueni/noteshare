module ImageManager::Controllers::Image
  class Search
    include ImageManager::Action

    expose :images, :active_item, :current_image

    def call(params)
      redirect_if_not_signed_in('editor, image,  Search')

      query_string = request.query_string

      if query_string and query_string =~ /current_image_id/
        tag, @current_image_id = query_string.split('=')
        @current_image = ImageRepository. find @current_image_id
      else
        @current_image = ImageActivityManager.new(user: current_user(session)).last_image
      end

      @active_item = 'images'
      key1 = params['search']
      @images = ImageRepository.search3(key1)

    end

  end
end

