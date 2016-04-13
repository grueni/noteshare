require 'net/http'
require 'uri'
require 'json'
require 'lotus/controller'
require 'lotus/action/session'


module Analytics

  def self.record_access(user, id, message)
    puts "analytics, record_access".red
    if user == nil
      user_name = 'NIL'
    else
      user_name = user.screen_name
    end

    Keen.publish(:access, {user: user_name, id: id, action: action, message: message}) if user_name != ENV['DEVELOPER_SCREEN_NAME']
  end

  def self.record_edit(user, document)
    return if ENV['INTERNET_OFF'] == 'yes'
    if user && user.screen_name != ENV['DEVELOPER_SCREEN_NAME']
        Keen.publish(:document_edit, { :username => user.screen_name, :document => document.title, :document_id => document.id })
    end
  end

  def self.record_new_document(user, document)
    return if ENV['INTERNET_OFF'] == 'yes'
    if user && user.screen_name != ENV['DEVELOPER_SCREEN_NAME']
      Keen.publish(:new_document, { :username => user.screen_name, :document => document.title, :document_id => document.id })
    end
  end

  def self.record_image_upload(user, image)
    return if ENV['INTERNET_OFF'] == 'yes'
    if user && user.screen_name != ENV['DEVELOPER_SCREEN_NAME']
      Keen.publish(:image_upload, { :username => user.screen_name, :image => image.title, :image_id => image.id })
    end
  end

  def self.record_new_section(user, document)
    return if ENV['INTERNET_OFF'] == 'yes'
    if user && user.screen_name != ENV['DEVELOPER_SCREEN_NAME']
      Keen.publish(:new_section, { :username => user.screen_name, :document => document.title, :document_id => document.id })
    end
  end


  def self.record_new_pdf_document(user, document)
    return if ENV['INTERNET_OFF'] == 'yes'
    if user && user.screen_name != ENV['DEVELOPER_SCREEN_NAME']
      Keen.publish(:new_pdf_document, { :username => user.screen_name, :document => document.title, :document_id => document.id })
    end
  end


  def self.record_document_view(user, document)
    return if ENV['INTERNET_OFF'] == 'yes'
    root_document = document.root_document
    if user
      user.dict2['current_document_id'] = document.id
      UserRepository.update user
      if user.screen_name != ENV['DEVELOPER_SCREEN_NAME']
        Keen.publish(:document_views_signed_in, { :username => user.screen_name,
                                                  :document => document.title, :document_id => document.id,
                                       :root_document => root_document.title, :root_document_id => root_document.id})

      end
    else
      Keen.publish(:anonymous_document_views, { :username => 'anonymous',
                                      :document => document.title, :document_id => document.id,
                                                :root_document => root_document.title, :root_document_id => root_document.id})
    end
  end

  def self.get_keen_data(hash)
    _hash = hash || {}
    query_type = _hash[:query_type] || 'count'
    collection = _hash[:collection] || 'document_views'
    time_frame = _hash[:time_frame] || 'this_7_days'

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