module Editor::Views::Document
  class Options
    include Editor::View

    def form
      puts "form OPTIONS".red
      puts document.dict.string_val(:vertical).cyan

      form_for :document, '/editor/update_options' do

        label :tags
        text_field :tags, {value: document.tags, style:'color:white;'}

        label :options
        text_area :options, document.dict.string_val(:vertical)

        hidden_field :document_id, value: params[:id]

        submit 'Update', {style: 'margin-top:1em;'}

        submit 'Cancel', {style: 'margin-top:1em;'}

      end
    end

  end
end
