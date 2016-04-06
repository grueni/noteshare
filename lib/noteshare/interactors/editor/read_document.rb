require 'lotus/interactor'
require_relative '../../../modules/analytics'
require_relative '../../../../lib/noteshare/classes/document/toc_presenter'

class ReadDocument

  include Lotus::Interactor
  expose :document, :root_document, :rendered_content, :table_of_contents

  def initialize(params, user)
    @user = user
    @document = DocumentRepository.find(params['id'])
    if @document == nil
      @error ='document not found'
    else
      @root_document = @document.root_document
    end
    if @document == @root_document and @document.rendered_content and @document.rendered_content == ''
      @document = @document.first_section
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
    DocumentActivityManager.new(@user).record(@document) if @user
    Analytics.record_document_view(@user, @document)
    prepare_rendered_content
    prepare_table_of_contents
  end

  def prepare_rendered_content
    if @document.rendered_content and @document.rendered_content != ''
      @rendered_content = @document.rendered_content
    else
      @rendered_content = "<p style='margin:3em;font-size:24pt;'>This block of the document is blank.  Please edit it or go to the next block</p>"
    end
  end

  def prepare_table_of_contents
    @table_of_contents = TOCPresenter.new(@document.root_document).root_table_of_contents(@document.id, 'document')
  end


end

