require_relative '../../../../lib/modules/analytics'

module Uploader::Controllers::Image
  class DoUpload
    include Uploader::Action

    require_relative '../../../../lib/aws'
    include Uploader::Action
    include Noteshare::AWS
    include Noteshare::Util
    include Analytics

    expose :url, :image, :message

    def call(params)
      redirect_if_not_signed_in('uploader, Image,  DoUpload')
      puts "Call  uploader, image, do-upload".magenta

      @title =  params['title']
      @tags =  params['tags']
      @filename = params['datafile']['filename']
      @tempfile = params['datafile']['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]
      @option = params['option']
      @originating_document_id = params['originating_document_id']

      puts "originating_document_id = #{@originating_document_id}".red

      _identifier = Identifier.new('image').string
      @filename =  "#{_identifier}_#{@filename}"
      @url = Noteshare::AWS.upload(@filename, @tempfile, 'noteshare_images' )

      if @url
        raw_image = Image.new(title: @title, file_name: @filename, url: @url, tags: @tags, dict: {})
        @image = ImageRepository.create raw_image
        session[:current_image_id] = @image.id
        user =  current_user(session)
        user.dict2['current_image_id'] = @image.id
        Analytics.record_image_upload(user, @image)
        UserRepository.update user
        @message = "Image upload successful (id: #{@image.id})"
      else
        @message = "Image upload failed"
      end

      if @option =~ /editor:.*/
        redirect_to "/editor/document/#{@originating_document_id}"
      else
        redirect_to "/image_manager/search?search=#{@image.title}"
      end
    end

    private
    def verify_csrf_token?
      false
    end

  end
end
