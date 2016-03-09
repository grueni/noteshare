module ImageManager::Views::Image
  class Show
    include ImageManager::View
    include Lotus::Helpers

    def form

      puts "In image update form, session = #{session.inspect}".cyan

      form_for :edit_image, "/image_manager/update/#{image.id}", class: '' do

        label :title
        text_field :title, value: image.title

        label :tags
        text_field :tags, value: image.tags

        label :source
        text_field :source, value: image.source

        submit 'Update',  class: "waves-effect waves-light btn"

      end
    end


  end
end
