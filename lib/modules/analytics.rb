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


  def self.get_page_views
    uri = URI.parse('https://api.keen.io/3.0/projects/569eb92ed2eaaa67e388d3b3/queries/count?api_key=8fd44a8395eaf4654e1515a3a9a7be2e1ffc20fa71c4bdc2fb2c4b76bcd75bb7651df2d8d8c6410a0925c34c9e681cf82e7221ac66722804f4c7f2d104622120afd18e3c6aff6b92a2e3b7b07bfd02f0a899ed4d69e0e51fd9514db3bfc42588&event_collection=document_views&timezone=US%2FEastern&timeframe=this_14_days&filters=%5B%5D')
    response_body = Net::HTTP.get_response(uri).body
    hash = JSON.parse response_body
    hash['result']
  end

end