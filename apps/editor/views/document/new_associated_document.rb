module Editor::Views::Document
  class NewAssociatedDocument
    include Editor::View

    def new_associated_document_form
      form_for :document, '/editor/create_new_associated_document' do
        label :title
        text_field :title

        label :type
        text_field :type

        label :content
        text_area :content

        hidden_field :current_document_id, value: params['id']

        submit 'Create'
      end
    end

  end
end

=begin

 text_area :content, {style: 'height:100px;'}

       radio_button :texmacros, 'TeX Macros', { type: 'radio',id: '1', class: 'ns_radio'}
        radio_button :summary, 'Summary',{type: 'radio',id: '2', class: 'ns_radio'}
        radio_button :notes, 'Notes', {type: 'radio',id: '3', class: 'ns_radio'}
        radio_button :other, 'Other',{ type: 'radio',id: '  4', class: 'ns_radio'}

=end