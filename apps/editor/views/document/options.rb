module Editor::Views::Document
  class Options
    include Editor::View

    def form
      puts ">> form OPTIONS".red
      form_for :document, '/editor/update_options' do
        label :area
        text_field :area, {value: document.area, style:'color:white;'}

        label :tags
        text_field :tags, {value: document.tags, style:'color:white;'}

        label :options
        text_area :options, {value: document.options, style: 'background-color: rgba(10,10,10,0.67); height:200px;margin-top:0.5em;'}

        hidden_field :document_id, style:'color:white;', value: params[:id]

        submit 'Update', {style: 'margin-top:1em;'}

        submit 'Cancel', {style: 'margin-top:1em;'}

      end
    end

  end
end
