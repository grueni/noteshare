require 'lotus/interactor'
# require_relative '../../.../lib/modules/analytics'
require_relative '../../../lib/modules/analytics'
require 'pry'

class ImageUploader

  include Lotus::Interactor
  expose :url, :image, :message, :originating_document_id

  def initialize(params, user)
    # binding.pry
    @user = user
    @title =  params['title']
    @tags =  params['tags']
    @datafile_packet = params['datafile'] || {}
    @filename = @datafile_packet['filename']
    @incoming_url = params['url']
    @option = params['option']
    @originating_document_id = params['originating_document_id']
  end

  def set_mode
    # binding.pry
    if @incoming_url && @incoming_url =~ /http/
      @mode = :from_url
    else
      @mode = :from_local_file
    end
    puts "mode = #{@mode.to_s}".red
  end

  def set_tempfile
    if @mode == :from_local_file
      @tempfile = @datafile_packet['tempfile'].inspect.match(/Tempfile:(.*)>/)[1]
    else
      @filename = @title.normalize
      file_suffix = @incoming_url.split('.').last
      @tempfile = "outgoing/images/foo.#{file_suffix}"
    end
  end

  def set_filename
    _identifier = Identifier.new('image').string
    if @mode == :from_url
      @filename =  "#{_identifier}_#{@title.normalize}"
    else
      @filename =  "#{_identifier}_#{@filename}"
    end

  end

  def configure
    set_mode
    set_tempfile
    set_filename
  end

  def bail_out
    @message = "Image upload failed"
    return
  end

  def upload
    if @mode == :from_url
      self.save_url_to_file(@incoming_url, @tempfile)
      @url = Noteshare::AWS.upload(@filename, @tempfile, 'noteshare_images' )
    else
      @url = Noteshare::AWS.upload(@filename, @tempfile, 'noteshare_images' )
    end
  end

  def call
    configure
    upload
    bail_out unless @url
    raw_image = Image.new(title: @title, file_name: @filename, url: @url, tags: @tags, dict: {})
    @image = ImageRepository.create raw_image
    @user.dict2['current_image_id'] = @image.id
    Analytics.record_image_upload(@user, @image)
    UserRepository.update @user
    @message = "Image upload successful (id: #{@image.id})"
  end

end
