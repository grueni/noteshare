



module Web::Views
  module Forms

    def basic_search_form
      form_for :search, '/search' do
        text_field :search, {style: 'position:absolute; top:-6px; left:100px;; padding-left: 20px; placeholder: Search for; color: white; background-color: #444; height: 28px; width:380px;'}
      end
    end

  end
end




