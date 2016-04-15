module Noteshare
  module Core
    module Publications
      class PublicationsRepository
        include Lotus::Repository

        def self.records_for_node(node_id)
          query do
            where(node_id: node_id)
          end
        end

        def self.records_for_document(document_id)
          query do
            where(document_id: document_id)
          end
        end

        def self.principal_publisher_for_document(document_id)
          query do
            where(document_id: document_id, type: 'principal')
          end
        end

        def self.record_for_pair(node_id, document_id)
          query do
            where(document_id: document_id, node_id: node_id)
          end.first
        end

      end

    end
  end
end


