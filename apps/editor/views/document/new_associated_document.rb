module Editor::Views::Document
  class NewAssociatedDocument
    include Editor::View

    def new_associated_document_form
      form_for :document, '/editor/create_new_section' do
        label :title
        text_field :title

        radio_button :type

        label :options
        text_field :options

        label :content
        text_area :content

        hidden_field :parent_id, value: params[:id]

        submit 'Create'
      end
    end

  end
end
