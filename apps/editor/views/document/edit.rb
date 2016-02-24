module Editor::Views::Document
  class Edit
    include Editor::View


    def form
      puts "form EDITOR".red

      form_for :document, '/editor/update' do

        text_area :updated_text,  document.content, { class: 'editor_input',  style: 'position: absolute; top:0'}

        hidden_field :document_id, value: document.id

      end
    end

    def rendered_content
      DocumentPresenter.new(document).rendered_content
    end
   
  end
end
