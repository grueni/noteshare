module Editor::Views::Documents
  class New
    include Editor::View

    def form
      
      form_for :document, '/documents' do
        text_field :title
        text_field :author

        submit 'Create'
      end
    end

  end
end
