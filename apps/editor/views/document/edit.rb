module Editor::Views::Document
  class Edit
    include Editor::View


    def form
      puts "form EDITOR".red

      form_for :document, '/editor/update' do

        text_area :updated_text,  document.content, { class: 'lined' }

        hidden_field :document_id, value: document.id

      end
    end
   
  end
end
