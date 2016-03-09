module ImageManager::Controllers::Image
  class Search
    include ImageManager::Action

    expose :images, :active_item, :current_image

    def call(params)
      redirect_if_not_signed_in('editor, image,  Search')

      query_string = request.query_string
      puts "SEARCH, query_string = #{query_string}".red
      if query_string and query_string =~ /current_image_id/
        puts 'AAAA'.cyan
        tag, @current_image_id = query_string.split('=')
        @current_image = ImageRepository. find @current_image_id
      else
        puts 'BBBB'.cyan
        if session['current_image_id']
          puts "SEARCH, session[:current_image_id] = #{session[:current_image_id]}".red
          @current_image = ImageRepository.find session[:current_image_id]
          puts "SEARCH, VERIFY: #{@current_image.id}".cyan
        else
          puts "SEARCH, NO CURRENT IMAGE ID"
        end
      end

      @active_item = 'images'
      key1 = params['search']
      puts "image search key = #{key1}".red
      @images = ImageRepository.search3(key1)



      puts "N = #{@images.count} documents images".magenta
      puts "image_manager search, reporting session[:current_document_id] as #{session[:current_document_id]}".red
      puts "image_manager search, reporting session[:current_image_id] as #{session[:current_image_id]}".red
    end

    private
    def verify_csrf_token?
      false
    end

  end
end

