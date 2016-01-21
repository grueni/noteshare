module Uploader::Controllers::File
  class Upload
    include Uploader::Action
    expose :active_item

    def call(params)
      redirect_if_not_signed_in('uploader, File,  Upload')
      @active_item = ''
    end
  end
end
