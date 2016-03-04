module Node::Views::Admin
  class EditSidebar
    include Node::View

    def sidebar_form

      sidebar_text = node.meta['sidebar_text'] || ''

      form_for :node, "/node/update_sidebar/#{node.id}" do

        label :sidebar
        text_area :sidebar_text,  sidebar_text

        hidden_field :node_id, value: node.id

        submit 'Update',  class: "waves-effect waves-light btn"

      end
    end


  end
end
