module Uploader::Controllers::File
  class DoUpload
    require_relative '../../../../lib/aws'
    include Uploader::Action
    include Noteshare::AWS
    include Noteshare::Util

    expose :image_id, :title, :filename, :url, :tags

    def call(params)
      puts "Call  uploader, file".magenta

      @title =  params['title']
      @tags = params['tags']
      @filename = params['datafile']['filename']
      tmpfile = params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]

      puts @title.cyan
      puts @tags.cyan
      puts @filename.cyan
      puts tmpfile.cyan

      @url = Noteshare::AWS.upload(@filename, tmpfile, 'test' )

      image = Image.new(title: @title, file_name: @filename, tags: @tags, url: @url)
      saved_image = Image.repository.create image
      @image_id = saved_image.id

    end

    private
    def verify_csrf_token?
      false
    end

  end
end
