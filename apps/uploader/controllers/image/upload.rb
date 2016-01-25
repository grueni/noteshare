module Uploader::Controllers::Image
  class Upload
    include Uploader::Action

    expose :option

    def call(params)
      redirect_if_not_signed_in('uploader, Image,  DoUpload')
      @option = request.query_string || 'standard'
    end
  end
end
