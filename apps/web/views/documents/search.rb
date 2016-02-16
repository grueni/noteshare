module Web::Views::Documents
  class Search
    include Web::View
    require_relative '../../../../lib/ui/links'
    include UI::Forms

    def test_form
      form_for :test, 'set_search_type' do
        text_field :title

        submit 'Create'
      end
    end

    def search_scope_selector
      form_for :search_type_selector, 'set_search_type', class: 'horizontal' do
        div do
          label :local
          radio_button :category, 'local', {value: 'local', id: 'select_local_search'}
          label :global
          radio_button :category, 'global', {value: 'global', id: 'select_global_search'}
          label :all
          radio_button :category, 'all', {value: 'all', id: 'select_all_search'}
        end
      end
    end


    def search_mode_selector
      form_for :search_type_selector, 'set_search_type', class: 'horizontal' do
        div do
          label :document
          radio_button :category, 'document', {value: 'document', id: 'select_document_search'}
          label :section
          radio_button :category, 'section', {value: 'section', id: 'select_section_search'}
          label :text
          radio_button :category, 'text', {value: 'text', id: 'select_text_search'}
        end
      end
    end

  end
end
