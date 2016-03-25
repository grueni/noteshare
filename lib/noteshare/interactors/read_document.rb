require 'lotus/interactor'
require_relative '../../modules/analytics'

class ReadDocument

  include Lotus::Interactor
  expose :document, :root_document

  def initialize(params, user)
    @user = user
    puts "BOSS, this the ReadDocument interactor"
    @document = DocumentRepository.find(params['id'])
    puts "interactor, @document = #{@document.id}, #{@document.title}"
    if @document == nil
      @error ='document not found'
    else
      @root_document = @document.root_document
    end
  end

  def validated
    return false if @error
    world_permission = @document.acl_get(:world)
    if @user == nil && !(world_permission =~ /r/)
      @error = 'Unauthorized'
      return false
    else
      return true
    end
  end

  def call
    return unless validated
    ContentManager.new(@document).update_content
    DocumentActivityManager.new(@user).record(@document)
    Analytics.record_document_view(@user, @document)
  end


end

