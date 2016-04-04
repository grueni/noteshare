module Web::Controllers::Document
  # Class link redirects an incoming request for a document
  # to a request for the same document prefixed by the
  # user's screen_name.  This is to ensure continuity
  # of user experience.
  class Link
    include Web::Action

    def configure_prefix
      referer = request.env["HTTP_REFERER"]
      part = referer.sub(/https?:\/\//, '').split('/')[0].split('.')
      prefix = part.shift
      stem = part.join('.')
      if ".#{stem}" == ENV['DOMAIN']
        @prefix = prefix
      else
        @prefix = 'www'
      end
    end

    def parse_query_string
      query_string = request.query_string
      if query_string =~ /ref:/
        ref_part, opt_part = query_string.split(',')
        @reference = ref_part.sub('ref:', '')
        @id = "#{@id}\##{@reference}"
        @stem = opt_part.sub('opt:', '')
      else
        @stem = query_string
      end
      @stem = 'document' if !['document', 'aside', 'view_source', 'compiled', 'titlepage'].include? @stem
    end

    def new_link(params)
      basic_link @prefix, "#{@stem}/#{@id}"
    end

    def call(params)
      @id = params['id']
      parse_query_string
      configure_prefix
      redirect_to new_link(params)
    end
  end
end


