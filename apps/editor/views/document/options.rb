module Editor::Views::Document
  class Options
    include Editor::View

    def form
      form_for :document, '/editor/documents' do
        label :options
        text_field :options

        label :area
        text_field :area


        label :tags
        text_field :options


        submit 'Update', {style: 'margin-top:1em;'}
        # button_to 'Cancel', "/documents/#{params[:id]}"
      end
    end

  end
end
