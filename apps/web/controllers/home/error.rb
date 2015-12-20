module Web::Controllers::Home
  class Error
    include Web::Action

    expose :error_message, :active_item

    def call(params)

      @error_message = "Error, code #{params[:id]}"

      @active_item = 'home'

      # puts request.env["rack.session.unpacked_cookie_data"].to_s.red
      # @message = Asciidoctor.convert @settings.get_key('message')

    end

  end
end
