module Uploader::Controllers::File
  class DoUpload
       require_relative '../../../../lib/aws'
    include Uploader::Action
    include Noteshare::AWS
    include Noteshare::Util

    expose :image_id, :title, :filename, :url, :tags, :active_item, :message

    def call(params)
      redirect_if_not_signed_in('uploader, File,  Settings')
      @active_item = ''
      puts "Call  uploader, file".magenta

      @filename = params['datafile']['filename']
      @title =  params['title'] || 'Test'
      @tags = params['tags'] || ''

      tmpfile = params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]

      puts @title.cyan
      puts @tags.cyan
      puts @filename.cyan
      puts tmpfile.cyan

      @url = Noteshare::AWS.upload(@filename, tmpfile, 'test' )

    end

  end
end
