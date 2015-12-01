module Uploader::Controllers::File
  class DoUpload
    require_relative '../../../../lib/aws'
    include Uploader::Action
    include Noteshare::AWS

    expose :message

    def call(params)
      puts "Call  uploader, file".magenta

      meta =  params['textline'].to_s.cyan
      filename = params['datafile']['filename']
      tmpfile = params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]

      puts meta.cyan
      puts filename.cyan
      puts tmpfile.cyan

      @message = Noteshare::AWS.upload(filename, tmpfile, 'test' )
    end

    private
    def verify_csrf_token?
      false
    end

  end
end
