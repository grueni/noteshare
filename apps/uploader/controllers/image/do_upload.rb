

module Uploader::Controllers::Image
  class DoUpload
    include Uploader::Action

    require_relative '../../../../lib/aws'
    include Uploader::Action
    include Noteshare::AWS
    include Noteshare::
    include Analytics

    expose :url, :image, :message, :payload

    def call(params)
      redirect_if_not_signed_in('uploader, Image,  DoUpload')
      puts "Call  uploader, image, do-upload".magenta
                                                                                                                                         puts "originating_document_id = #{@originating_document_id}".red
      @payload = ImageUploader.new(params, current_user(session) ).call
      @url = @payload.url
      @image = @payload.image

      session[:current_image_id] = @image.id


     if @payload.originating_document_id
        redirect_to "/editor/document/#{@payload.originating_document_id}"
      else
        redirect_to "/image_manager/search?search=#{@image.title}"
      end
    end


  end
end
