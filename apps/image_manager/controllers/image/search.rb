module ImageManager::Controllers::Image
  class Search
    include ImageManager::Action

    expose :images

    def call(params)
      key1 = params['search']
      @images = ImageRepository.search3(key1)
      puts "N = #{@images.count} documents images".magenta
    end

    private
    def verify_csrf_token?
      false
    end

  end
end

