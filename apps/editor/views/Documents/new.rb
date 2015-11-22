module Editor::Views::Documents
  class New
    include Editor::View

    def form_title
      parent_doc = DocumentRepository.find params[:id]
      if parent_doc == nil
        puts "in form_title, parent_doc is nil"
      else
        puts "in form_title, parent_doc is #{parent_doc.title}"
      end
      if parent_doc
        "Add document to #{parent_doc.title}"
      else
        "Add new document"
      end
    end

    def form
      form_for :document, '/editor/documents' do
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
