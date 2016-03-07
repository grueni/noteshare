# require 'lotus/apps/web'


module Web
  module Views
    module Forms

      def basic_search_form
        form_for :search, '/search' do
          text_field :search, {id: 'basic_search_form', style: 'margin-left: 40px;'}
        end
      end

      def basic_search_form_short
        form_for :search, '/search' do
          text_field :search, {style: 'position:absolute; top:-6px; left:34  s0px;; padding-left: 20px; placeholder: Search for; color: white; background-color: #444; height: 28px; width:180px;'}
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


