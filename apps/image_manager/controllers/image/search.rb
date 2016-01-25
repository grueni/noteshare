module ImageManager::Controllers::Image
  class Search
    include ImageManager::Action

    expose :images, :active_item

    def call(params)
      redirect_if_not_signed_in('editor, image,  Search')
      @active_item = 'images'
      key1 = params['search']
      puts "image search key = #{key1}".red
      @images = ImageRepository.search3(key1)
      puts "N = #{@images.count} documents images".magenta
      puts "image_manager search, reporting session[:current_document_id] as #{session[:current_document_id]}".red
    end

    private
    def verify_csrf_token?
      false
    end

  end
end

