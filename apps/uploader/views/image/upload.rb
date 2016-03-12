module Uploader::Views::Image
  class Upload
    include Uploader::View

    def image_upload_form
      form_for :command_processor, '/admin/do_image_upload' do
        text_field :command, {id: 'command_form', style: 'margin-left:0;'}
        hidden_field :secret_token, value: ENV['COMMAND_SECRET_TOKEN'], placeholder: 'command'
        submit 'Execute',  class: "waves-effect waves-light btn", style: 'margin-top:3em;'
      end
    end


  end
end
