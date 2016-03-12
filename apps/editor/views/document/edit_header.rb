module Editor::Views::Document
  class EditHeader
    include Editor::View

    def form

      id = params[:id]

      form_for :document_header, "/editor/update_header/#{params[:id]}" do
        # hidden_field :parent_id, value: params[:id]
        label 'document_header'
        text_area :header_content, document.content
        submit 'Update'

      end
    end

  end
end
