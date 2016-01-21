module Uploader::Controllers::Image
  class Upload
    include Uploader::Action

    def call(params)
      redirect_if_not_signed_in('uploader, Image,  DoUpload')
    end
  end
end
