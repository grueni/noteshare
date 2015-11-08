module ImageManager::Controllers::Image
  class Upload
    include ImageManager::Action

    def call(params)
      puts "ImageManager, Image. Upload".red
      image_data = params['image']
      file_name = image_data['file_name']
      title = image_data['title']
      puts "title = #{title}, filename = #{file_name}".red
      message = Image.upload(file_name)
      self.body = message
    end
  end
end
