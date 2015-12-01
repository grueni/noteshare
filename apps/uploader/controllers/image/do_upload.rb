module Uploader::Controllers::Image
  class DoUpload
    include Uploader::Action

    require_relative '../../../../lib/aws'
    include Uploader::Action
    include Noteshare::AWS
    include Noteshare::Util

    expose :message, :title, :tags, :filename

    def call(params)
      puts "Call  uploader, file".magenta

      @title =  params['title']
      @tags =  params['tags']
      @filename = params['datafile']['filename']
      @tmpfile = params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]

      puts title.cyan
      puts tags.cyan
      puts filename.cyan
      puts tmpfile.cyan

      @message = Noteshare::AWS.upload(@filename, @tmpfile, 'noteshare_images' )
      # @message = Noteshare::Util.read(filename, tmpfile )
    end

    private
    def verify_csrf_token?
      false
    end

  end
end
