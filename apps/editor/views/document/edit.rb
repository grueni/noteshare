module Editor::Views::Document
  class Edit
    include Editor::View


    def form
      puts ">> form EDITOR".red

      form_for :document, '/editor/update' do

        text_area :updated_text,  document.content

        hidden_field :document_id, value: document.id

        submit 'Update', {id: 'text_update_button', class: 'footer_button_1'}
      end
    end
   
  end
end
