module Web::Controllers::Document
  # Class link redirects an income request for a document
  # to a request for the same document prefixed by the
  # user's screen_name.  This is to ensure continuity
  # of experience.
  class Link
    include Web::Action

    def configure_prefix
      @prefix = 'www'
      cu = current_user(session)
      @prefix = cu.screen_name if cu
      @prefix
    end

    def new_link(params)
      query = request.query_string
      case query
        when 'aside'
          stem = 'aside'
        when 'view_source'
          stem = 'view_source'
        when 'compiled'
          stem = 'compiled'
        when 'titlepage'
          stem = 'titlepage'
        else
          stem = 'document'
      end
      reference = request.query_string || ''
      id = params['id']
      if reference == ''
        basic_link @prefix, "#{stem}/#{id}"
      else
        basic_link @prefix, "#{stem}/#{id}\##{reference}"
      end
    end

    def call(params)
      configure_prefix
      redirect_to new_link(params)
    end
  end
end
