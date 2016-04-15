require 'lotus/interactor'

module Noteshare
  module Interactor
    module Node

      class UpdateNodeBlurb
        include ::Noteshare::Core::Node

        include Lotus::Interactor
        expose :new_document, :error

        def initialize(node_id, blurb_text)
          @node =  NSNodeRepository.find node_id
          @node.meta['long_blurb'] = blurb_text
        end

        def call
          @node.update_blurb
          NSNodeRepository.update @node
        end

      end

    end
  end
end
