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
    end
    
    def parse_query_string
      @stem = request.query_string || 'document'
    end

    def new_link(params)
      id = params['id']
      basic_link @prefix, "#{@stem}/#{id}"
    end

    def call(params)
      parse_query_string
      configure_prefix
      redirect_to new_link(params)
    end
  end
end
