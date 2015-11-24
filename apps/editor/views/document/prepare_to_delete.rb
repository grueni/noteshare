module Editor::Views::Document
  class PrepareToDelete
    include Editor::View

    def form
      puts ">> form OPTIONS".red
      form_for :document, '/editor/update_options' do
        label :destroy
        text_field :destroy

        submit 'Destroy', {style: 'margin-top:1em;'}
        # button_to 'Cancel', "/documents/#{params[:id]}"
      end
    end

  end
end
