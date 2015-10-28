module Editor::Views::Document
  class Options
    include Editor::View

    def form
      puts ">> form OPTIONS".red
      form_for :document, '/editor/update_options' do
        label :options
        text_field :options

        label :area
        text_field :area, {value: document.area}


        label :tags
        text_field :tags, {value: document.tags}

        hidden_field :document_id, value: params[:id]

        submit 'Update', {style: 'margin-top:1em;'}
        # button_to 'Cancel', "/documents/#{params[:id]}"
      end
    end

  end
end
