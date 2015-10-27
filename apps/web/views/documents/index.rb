module Web::Views::Documents
  class Index
    include Web::View


    def left_menu
      html.tag(:a, 'New', href: '/editor/new')
    end

    def search_form

      form_for :search, '/search' do
        text_field :search, {style: 'inline-display;'}
        submit 'search', {style: 'inline-display;'}
      end

    end
    

  end
end
