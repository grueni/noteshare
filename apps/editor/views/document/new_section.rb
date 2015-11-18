module Editor::Views::Document
  class NewSection
    include Editor::View

    def new_section_form
      form_for :document, '/editor/create_new_section' do
        label :title
        text_field :title

        label :options
        text_field :options

        label :content
        text_area :content, {style: 'height:200px;'}

        hidden_field :parent_id, value: params[:id]

        submit 'Create', {style: 'margin-top:1em;'}
        # button_to 'Cancel', "/documents/#{params[:id]}"
      end
    end

  end
end
