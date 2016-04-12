  require_relative '../../../../lib/noteshare/interactors/editor/create_section'

module Editor::Controllers::Document
  class CreateNewSection
    include Editor::Action
    include Noteshare::Interactor::Document

    expose :active_item

    def call(params)
      @active_item = 'editor'
      result = CreateSection.new(params).call
      if result.error
        redirect_to "/error/0?#{result.error}"
      else
        flash[:notice] = "New section created"
        redirect_to "/editor/document/#{result.new_document.id}"
      end
    end

  end
end
