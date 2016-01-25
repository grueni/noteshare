module ImageManager::Controllers::Image
  class Search
    include ImageManager::Action

    expose :images, :active_item, :current_image

    def call(params)
      redirect_if_not_signed_in('editor, image,  Search')
      @active_item = 'images'
      key1 = params['search']
      puts "image search key = #{key1}".red
      @images = ImageRepository.search3(key1)

      if session['current_image_id']
        puts "session['current_image_id'] = #{session['current_image_id']}".red
        @current_image = ImageRepository.find session['current_image_id']
        puts "VERIFY: #{@current_image.id}".cyan
      end

      puts "N = #{@images.count} documents images".magenta
      puts "image_manager search, reporting session[:current_document_id] as #{session[:current_document_id]}".red
    end

    private
    def verify_csrf_token?
      false
    end

  end
end

