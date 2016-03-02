module Editor::Views::Document
  class NewSection
    include Editor::View

    def new_section_title
      if document.is_root_document?
        "New section for #{document.title}"
      else
        "New section at #{document.title}"
      end
    end

    def new_section_form
      form_for :document, '/editor/create_new_section' do
        label :title
        text_field :title

        # label :content
        # text_area :content



        if !document.is_root_document?
          div do
            label :position

            label :above
            radio_button :create_mode, 'above', {value: 'sibling_above', id: 'select_sibling_above'}

            label :below
            radio_button :create_mode, 'below', {value: 'sibling_below', id: 'select_sibling_below'}

            label :subdocument
            radio_button :create_mode, 'subdocument', {value: 'child', id: 'select_subdocument'}
          end
        end


        hidden_field :parent_id, value: params[:id]
        hidden_field :current_document_id, value: document.id
        # hidden_field :create_mode, value: create_mode

        submit 'Create'

      end
    end



  end
end
