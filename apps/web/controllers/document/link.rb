module Web::Controllers::Document
  # Class link redirects an income request for a document
  # to a request for the same document prefixed by the
  # user's screen_name.  This is to ensure continuity
  # of experience.
  class Link
    include Web::Action

    def configure_prefix
      cu = current_user(session)
      cu ? @prefix = cu.screen_name : 'www'
    end

    def new_link(params)
      reference = request.query_string || ''
      id = params['id']
      if reference == ''
        basic_link @prefix, "document/#{id}"
      else
        basic_link @prefix, "document/#{id}\##{reference}"
      end
    end

    def call(params)
      configure_prefix
      redirect_to new_link(params)
    end
  end
end
