module Web::Controllers::Home
  class Error
    include Web::Action

    expose :error_message, :active_item

    def call(params)

      @error_message = ErrorReporter.new(params[:id], request.query_string).message

      @active_item = 'home'

    end

  end
end
