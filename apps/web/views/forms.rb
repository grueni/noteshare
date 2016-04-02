# require 'lotus/apps/web'


module Web
  module Views
    module Forms

      def basic_search_form
        form_for :search, '/search' do
          text_field :search, {id: 'basic_search_form', style: 'margin-left: 40px;width:80%', placeholder: 'Search ...'}
        end
      end

      def basic_search_form_phone
        form_for :search, '/search' do
          text_field :search, {id: 'basic_search_form', style: 'margin-left: -70px;margin-top:8px;  width:80%', placeholder: 'Search ...'}
        end
      end

      def basic_search_form_short
        form_for :search, '/search' do
          text_field :search, {style: 'position:absolute; top:-6px; padding-left: 20px; color: white; background-color: #444; height: 28px; width:180px;', placeholder: 'Search ...'}
        end
      end

      def small_search_form
        form_for :search, '/search' do
          text_field :search, {style: 'position:absolute; top:-6px; left:40px; padding-left: 20px; placeholder: Search for; color: white; background-color: #444; height: 28px; width:100px;'}
        end
      end

    end
  end
end


