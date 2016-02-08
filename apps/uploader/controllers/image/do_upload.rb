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

      # PROBLEM IS HERE -- current_document_id CHANGES
      puts "WARNING:".magenta
      puts "In image upload, option = #{@option}, current_document_id = #{session['current_document_id']}".red
      puts "----------------------------".magenta

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

      if @option == 'editor' && session['current_document_id']
        puts "UPLOADER IS REDIRECTING TO EDITOR WITH CURRENT DOCUMENT ID = #{session['current_document_id']}".magenta
        redirect_to "/editor/document/#{session['current_document_id']}"
      end
    end

    private
    def verify_csrf_token?
      false
    end

  end
end
