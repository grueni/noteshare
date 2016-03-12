
# ActivityManager records
# the documents a user
# views and can present
# a list of this activity
class ImageActivityManager

  attr_reader :last_image_id, :last_image_title

  def initialize(hash)
    @image = hash[:image]
    @user = hash[:user]
    @configured = false
  end

  def record
    return if @user == nil
    array = @user.images_visited
    iv = ImagesVisited.new(array, ENV['IMAGES_VISITED_CAPACITY'])
    iv.push_image(@image)
    @user.images_visited = iv.stack
    UserRepository.update @user
  end


  def configure
    array = @user.images_visited || []
    @object = ImagesVisited.new(array, ENV['IMAGES_VISITED_CAPACITY'])
    @stack = @object.stack
    last_item = @stack.last
    if last_item
      @last_image_id = last_item.keys[0]
      @last_image_title = last_item.values[0]
    end
    @configured = true
  end


  # @document can be nil for this method:
  def list
    configure if not @configured
    output = "<ul>\n"
    @stack.reverse.each do |item|
      image_id = item.keys[0]
      data = item[image_id]
      image_name = data[0]
      output << "<li> <a href='/image/#{image_id}'>#{image_name}</a></li>\n"
    end
    output << "</ul>\n"
    output
  end

  def last_id
    configure if not @configured
    @last_image_id
  end

  def last_image
    ImageRepository.find last_id
  end

end