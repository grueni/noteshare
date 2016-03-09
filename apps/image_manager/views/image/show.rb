module ImageManager::Views::Image
  class Show
    include ImageManager::View
    include Lotus::Helpers

    def form

      form_for :edit_image, "/image_manager/update/#{image.id}", class: '' do

        label :title
        text_field :title, image.title

        label :tags
        text_field :tags, image.tags

        label :source
        text_field :source, image.source

        submit 'Update',  class: "waves-effect waves-light btn"

      end
    end


  end
end
