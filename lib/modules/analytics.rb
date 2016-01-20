require 'net/http'
require 'uri'
require 'json'

module Analytics

  def self.record_page_visit(user, document)
    puts "analytics".red
    if user
      if !user.admin
        Keen.publish(:document_views, { :username => user.screen_name,
                                        :document => document.title, :document_id => document.id })
      end
    else
      Keen.publish(:document_views, { :username => 'anonymous',
                                      :document => document.title, :document_id => @ocument.id })
    end
  end



  def self.get_keen_data(hash)
    _hash = hash || {}
    query_type = _hash['query_type'] || 'count'
    collection = _hash['collection'] || 'document_views'
    time_frame = _hash['time_frame'] || 'this_14_days'

    proj_id = ENV['KEEN_PROJECT_ID']
    read_key = ENV['KEEN_READ_KEY']

    route = "https://api.keen.io/3.0/projects/#{proj_id}/queries/#{query_type}?api_key=#{read_key}&event_collection=#{collection}&timezone=US%2FEastern&timeframe=#{time_frame}&filters=%5B%5D"
    uri = URI.parse(route)
    puts route.red
    response_body = Net::HTTP.get_response(uri).body
    hash = JSON.parse response_body
    hash['result']
  end

  def self.get_average_page_view_counts
    uri = URI.parse('https://api.keen.io/3.0/projects/569eb92ed2eaaa67e388d3b3/queries/count?api_key=8fd44a8395eaf4654e1515a3a9a7be2e1ffc20fa71c4bdc2fb2c4b76bcd75bb7651df2d8d8c6410a0925c34c9e681cf82e7221ac66722804f4c7f2d104622120afd18e3c6aff6b92a2e3b7b07bfd02f0a899ed4d69e0e51fd9514db3bfc42588&event_collection=document_views&timezone=US%2FEastern&timeframe=this_14_days&filters=%5B%5D')
    response_body = Net::HTTP.get_response(uri).body
    hash = JSON.parse response_body
    hash['result']
  end

end