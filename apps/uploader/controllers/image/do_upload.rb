module Uploader::Controllers::Image
  class DoUpload
    include Uploader::Action

    require_relative '../../../../lib/aws'
    include Uploader::Action
    include Noteshare::AWS
    include Noteshare::Util

    expose :url, :image, :message

    def call(params)
      puts "Call  uploader, file".magenta

      @title =  params['title']
      @tags =  params['tags']
      @filename = params['datafile']['filename']
      @tempfile = params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]

      _identifier = Identifier.new('image').string
      @filename =  "#{_identifier}_#{@filename}"

      puts @title.cyan
      puts @tags.cyan
      puts @filename.cyan
      puts @tempfile.cyan

      @url = Noteshare::AWS.upload(@filename, @tempfile, 'noteshare_images' )

      if @url
        raw_image = Image.new(title: @title, file_name: @filename, url: @url, tags: @tags, dict: {})
        @image = ImageRepository.create raw_image
        @message = "Image upload successful (id: #{@image.id})"
      else
        @message = "Image upload failed"
      end


      # @message = Noteshare::Util.read(filename, tmpfile )
    end

    private
    def verify_csrf_token?
      false
    end

  end
end
