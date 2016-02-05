module Node::Views::Admin
  class EditBlurb
    include Node::View

    def blurb_form

      blurb_text = node.meta['long_blurb'] || ''

      form_for :node, "/node/update_blurb/#{node.id}" do

        label :blurb
        text_area :blurb,  blurb_text

        hidden_field :node_id, value: node.id

        submit 'Update',  class: "waves-effect waves-light btn"

      end
    end

  end
end
