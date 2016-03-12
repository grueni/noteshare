module Uploader::Controllers::Image
  class Upload
    include Uploader::Action

    expose :option, :document_id

    def call(params)
      redirect_if_not_signed_in('uploader, Image,  DoUpload')
      query_string = request.query_string
      puts "controller image  upload, query_string = #{query_string}".green
      @option = request.query_string || 'standard'
      if query_string
        prefix, @document_id = query_string.split(':')
      end
    end
  end
end
