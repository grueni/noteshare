module Web::Controllers::Document
  # Class link redirects an income request for a document
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
      puts "request.query_string: #{request.query_string}".red
      @stem = request.query_string || 'document'
      @stem = 'document' if !['document', 'aside', 'view_source', 'compiled', 'titlepage'].include? @stem
      puts "@stem: #{@stem}".red
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
