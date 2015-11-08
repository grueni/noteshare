


module ImageManager::Views::Image
  class New
    include ImageManager::View

    def form
      puts ">> form NEW Image".red

      form_for :image, '/image_manager/upload', class: 'image new' do

        label :title
        text_field :title

        label :file_name
        text_field :file_name

        submit 'Create image',  class: "waves-effect waves-light btn"

      end

    end

  end

end


