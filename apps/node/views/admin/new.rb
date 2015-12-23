module Node::Views::Admin
  class New
    include Node::View

    def form
      puts ">> form NEW Image".red

      form_for :new_node, '/node/create', class: '' do

        label :name
        text_field :name

        label :owner_id
        text_field :owner_id

        label :type
        text_field :type

        label :tags
        text_field :tags

        submit 'Create node',  class: "waves-effect waves-light btn"

      end
    end


  end
end
