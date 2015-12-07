module Uploader::Controllers::File
  class Upload
    include Uploader::Action
    expose :active_item

    def call(params)
      @active_item = ''
    end
  end
end
