module Editor::Views::Documents
  class New
    include Editor::View


    def form
      form_for :document, '/editor/documents' do
        label :title
        text_field :title

        # label :content
        # text_area :content, {style: 'height:200px;'}

        hidden_field :parent_id, value: params[:id]

        submit 'Create', {style: 'margin-top:1em;'}

        submit 'Cancel', {style: 'margin-top:1em;'}
        # button_to 'Cancel', "/documents/#{params[:id]}" 
      end
    end

  end
end
