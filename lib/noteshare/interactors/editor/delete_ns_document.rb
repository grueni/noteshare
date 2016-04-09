require 'lotus/interactor'

class DeleteNSDocument

  include Lotus::Interactor
  expose :document, :root_document, :error, :message, :redirect_path

  def initialize(params, user)
    @user = user
    @control =  params['document']['destroy']
    doc_id =  params[:id]
    @delete_mode = params['document']['delete_mode']
    @document = DocumentRepository.find doc_id
    @error = nil
    @message = ''
  end

  def call

    parent_id = @document.parent_document.id if @document.parent_document
    document_id = @document.id

    if Permission.new(@user, :delete,  @document).grant == false
      @error = 'permission to delete document not granted'
      @redirect_path =  "/error/0?#{@error}"
      return
    end


    if @control != 'destroy'
      @message << "You did not say 'destroy'"
      @error = 'deletion of documnt not confirmed'
      @redirect_path =  "/error/0?#{@error}"
      return
    end

    if @delete_mode == 'section'
      @document.delete_subdocument
      @message << "#{@document.title} has been deleted."
      if parent_id != document_id
        @redirect_path =  "/editor/document/#{parent_id}"
      else
        @redirect_path = "/node/user/#{@user.id}"
      end
    end

    if @delete_mode == 'tree'
      DocumentRepository.destroy_tree @document.id, [:verbose, :kill]
      @message << "#{@document.title} and it entrie document tree has been deleted."
      @redirect_path = "/node/user/#{@user.id}"
    end
  end


end
