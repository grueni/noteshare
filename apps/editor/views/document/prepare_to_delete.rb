module Editor::Views::Document
  class PrepareToDelete
    include Editor::View

    def form
      puts "form PrepareToDelete".red
      form_for :document, "/editor/delete_document/#{document.id}" do
        label :destroy
        text_field :destroy

        hidden_field :document_id, value: document.id
        hidden_field :delete_mode, value: delete_mode

        submit 'Destroy', {style: 'margin-top:1em;'}
        # button_to 'Cancel', "/documents/#{params[:id]}"
      end
    end

  end
end
