class Document
  include Lotus::Entity
  attributes :id, :identifier, :author, :title, :tags, :meta,
    :createdAt, :modifiedAt, :text, :parts
end
