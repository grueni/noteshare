module Editor::Views::Document
  class MiniEdit
    include Editor::View
    include Noteshare::Presenter::Document

    def form
      puts "form EDITOR".red

      form_for :document, '/editor/update' do

        text_area :updated_text,  document.content, { class: 'editor_input',  style: 'position: absolute; top:0'}

        hidden_field :document_id, value: document.id

      end
    end


    def document_presenter
      DocumentPresenter.new(document)
    end

    def toc_presenter
      TOCPresenter.new(document.root_document)
    end

  end
end
