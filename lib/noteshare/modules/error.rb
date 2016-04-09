module Noteshare

  module ErrorHandler


    def redirect_to_path(path)
      redirect_to path if path
    end

    def handle_error(error)
      if error && error.downcase =~ /unauthorized/
        halt 401
      elsif error != nil
        redirect_to "/error/0/?#{error}"
      end
    end

    # If the 'document' is nil, redirect the request
    # to an error page with information in the header
    # about the nature of the error
    def handle_nil_document(document, code)
      if document == nil
        redirect_to "/error/#{code}/?document_not_found"
      end
    end

  end

  class ErrorReporter

    def initialize(code, query_string)
      @code = code
      @query = query_string.gsub('%20', ' ')
    end

    def message
      if @code
        "Error #{@code}: #{@query}"
      else
        "Error: #{@query}"
      end
    end

  end

end

