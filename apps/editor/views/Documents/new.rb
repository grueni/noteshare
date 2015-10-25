module Editor::Views::Documents
  class New
    include Editor::View

    def form_title
      if params[:id]
        parent_doc = DocumentRepository.find params[:id]
        "Add document to #{parent_doc.title}"
      else
        "Add new document"
      end
    end

    def form
      form_for :document, '/editor/documents' do
        label :title
        text_field :title

        label :content
        text_area :content, {style: 'height:200px;'}

        hidden_field :parent_id, value: params[:id]

        submit 'Create', {style: 'margin-top:1em;'}
      end
    end
  end
end
