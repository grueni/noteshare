module Admin::Views::Documents
  class List
    include Admin::View

    def search_form
      form_for :search, '/admin/search' do
        text_field :search, {id: 'basic_search_form', style: 'margin-left: 40px;width:80%', placeholder: 'Search ...'}
      end
    end


  end
end
