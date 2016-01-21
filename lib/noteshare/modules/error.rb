module Noteshare

  module ErrorHandler

    # If the 'document' is nil, redirect the request
    # to an error page with information in the header
    # about the nature of the error
    def handle_nil_document(document, code)
      puts "ENTER: handle_nil_document with code #{code}".red
      if document == nil
        redirect_to "/error/#{code}/?document_not_found"
      end
    end

  end

  class ErrorReporter

    def initialize(code, query_string)
      @code = code
      @query = query_string
    end

    def message
      case @query
        when 'document_not_found'
          "Document #{@code} not found.  Perhaps it has been deleted."
        else
          "Error code #{@code} — #{@query.gsub('%20', ' ')}"
      end
    end

  end

end

