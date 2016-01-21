require 'net/http'
require 'uri'
require 'json'

module Analytics

  def self.record_access(user, id, action, message)
    if user == nil
      user_name = 'NIL'
    else
      user_name = user.screen_name
    end
    Keen.publish(:access, {user: user_name, id: id, action: action, message: message})
  end

  def self.record_page_visit(user, document)
    puts "analytics".red
    if user
      if !user.admin
        Keen.publish(:document_views_signed_in, { :username => user.screen_name,
                                        :document => document.title, :document_id => document.id })
      end
    else
      Keen.publish(:anonymous_document_views, { :username => 'anonymous',
                                      :document => document.title, :document_id => document.id })
    end
  end

  def self.get_keen_data(hash)
    _hash = hash || {}
    query_type = _hash[:query_type] || 'count'
    collection = _hash[:collection] || 'document_views'
    time_frame = _hash[:time_frame] || 'this_14_days'

    proj_id = ENV['KEEN_PROJECT_ID']
    read_key = ENV['KEEN_READ_KEY']

    route = "https://api.keen.io/3.0/projects/#{proj_id}/queries/#{query_type}?api_key=#{read_key}&event_collection=#{collection}&timezone=US%2FEastern&timeframe=#{time_frame}&filters=%5B%5D"
    uri = URI.parse(route)


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


end