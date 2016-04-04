require_relative '../../../../lib/noteshare/interactors/editor/update_options'

module Editor::Controllers::Document
  class UpdateOptions
    include Editor::Action

    expose :document, :active_item

    def call(params)
      @active_item = 'editor'
      result = UpdateOptions.new(params).call
      @document = result.document
      redirect_to "/editor/document/#{id}"
    end

  end
end
