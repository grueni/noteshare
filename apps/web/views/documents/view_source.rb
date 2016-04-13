module Web::Views::Documents
  class ViewSource
    include Web::View
    include Noteshare::Presenter::Document

    def document_presenter
      DocumentPresenter.new(document)
    end

    def form
      puts "form EDITOR".red

      form_for :document, '/editor/update' do

        text_area :updated_text,  document.content, { class: 'source_text',  style: 'position: absolute; top:0'}

        hidden_field :document_id, value: document.id

      end
    end

  end
end
