module Editor::Views::Documents
  class New
    include Editor::View

    def form

      puts "IN FORM: params[:id] = #{params[:id]}"
      
      form_for :document, '/editor/documents' do
        text_field :title
        text_field :author

        hidden_field :parent_id, value: params[:id]

        submit 'Create'
      end

    end

  end
end
