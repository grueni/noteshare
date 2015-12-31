module Web::Controllers::Home
  class Error
    include Web::Action

    expose :error_message, :active_item

    def call(params)

      if params[:id]
        @error_message = ErrorReporter.new(params[:id], request.query_string).message
      else
        @error_message = "Error: no id given to find resource (document, node, etc)."
      end


      @active_item = 'home'

    end

  end
end
