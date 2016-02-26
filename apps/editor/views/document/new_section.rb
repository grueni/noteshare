module Editor::Views::Document
  class NewSection
    include Editor::View

    def new_section_title
      "New section for #{document.title}"
    end

    def new_section_form
      form_for :document, '/editor/create_new_section' do
        label :title
        text_field :title

        # label :content
        # text_area :content

        label :position
        div do
          label :above
          radio_button :create_mode, 'above', {value: 'sibling_above', id: 'select_sibling_above'}

          label :below
          radio_button :create_mode, 'below', {value: 'sibling_below', id: 'select_sibling_below'}

          label :subdocument
          radio_button :create_mode, 'subdocument', {value: 'child', id: 'select_subdocument'}
        end

        hidden_field :parent_id, value: params[:id]
        hidden_field :current_document_id, value: document.id
        # hidden_field :create_mode, value: create_mode

        submit 'Create'

      end
    end



  end
end
