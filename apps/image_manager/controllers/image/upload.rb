module ImageManager::Controllers::Image
  class Upload
    include ImageManager::Action

    def call(params)
      puts "ImageManager, Image. Upload".red
=begin
      image_data = params['image']
      file_name = image_data['file_name']
      title = image_data['title']
      puts "title = #{title}, filename = #{file_name}".red
      message = Image.upload(file_name)
=end
      self.body = "Hi there!" # message
    end
  end
end
