module ImageManager::Controllers::Image
  class List
    include ImageManager::Action

    expose :images, :active_item

    def call(params)
      @active_item = 'images'
      search_key = params['search']
      if search_key == nil
        @images = ImageRepository.all.random_sublist(12)
      elsif search_key == ''
        @images = ImageReposit                                                                     ory.all.random_sublist(12)
      else
        hash = ImageRepository.search(search_key).all
        puts "hash: #{hash}".magenta
        ids = hash.select{  |item| item[item.keys[0]] != nil}
        puts "ids: #{ids}"
        @images = hash_array.map { |id| ImageRepository.find(id)}
      end
      puts "N = #{@images.count} documents found".magenta
    end

    private
    def verify_csrf_token?
      false
    end

  end
end
