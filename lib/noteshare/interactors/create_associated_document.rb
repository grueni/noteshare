require 'lotus/interactor'

class CreateAssociatedDocument

  include Lotus::Interactor
  expose :current_document, :error

  def initialize(params)
    document_packet = params['document']
    @title = document_packet['title']
    @type = document_packet['type']
    @type = 'note' if @type == ''
    @content = document_packet['content']
    @current_document_id = document_packet['current_document_id']
    @current_document = DocumentRepository.find @current_document_id
    @author_id = @current_document.author_credentials2['id']
    @author = UserRepository.find @author_id
    @error = nil
  end

  def validate_document
    if @title == nil or @title == ''
      @error = '/error/:0?Please enter a title for the new document'
      return
    end

    if @type == nil or @type == ''
      @error = '/error/:0?Please enter a type e.g., note, aside, or texmacro'
      return
    end
  end

  def create
    @new_document = NSDocument.create(title: @title, content: @content, author_credentials: @author.credentials)
    #Fixme: the following is to be deleted when author_id is retired
    @new_document.author_id = @author.id
    @new_document.acl = @current_document.root_document.acl
    ContentManager.new(@new_document).update_content(nil)
    DocumentRepository.update @new_document
  end

  def call
    validate_document
    create
    @new_document.associate_to(@current_document, @type)
  end

end
