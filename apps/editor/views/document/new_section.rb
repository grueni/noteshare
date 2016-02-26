module Editor::Views::Document
  class NewSection
    include Editor::View

    def new_section_title

      case create_mode
        when 'child'
          "New section: child of #{document.title}"
        when 'sibling_after'
          "New section: sibling #{document.title} (below)"
        when  'sibling_before'
          "New section: sibling of #{document.title} (above)"
        else
          "New section for #{document.title}"
      end

    end

    def new_section_form
      form_for :document, '/editor/create_new_section' do
        label :title
        text_field :title

        # label :content
        # text_area :content

        hidden_field :parent_id, value: params[:id]
        hidden_field :current_document_id, value: document.id
        hidden_field :create_mode, value: create_mode

        submit 'Create'

      end
    end

  end
end
