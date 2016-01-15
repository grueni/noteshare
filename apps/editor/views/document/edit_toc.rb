module Editor::Views::Document
  class EditToc
    include Editor::View

    def update_toc_form

      form_for :document, "/editor/update_toc/#{document.id}" do
        # hidden_field :parent_id, value: params[:id]

        submit 'Update'

      end
    end

  end
end
