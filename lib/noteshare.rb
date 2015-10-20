require 'lotus/model'
require 'lotus/mailer'
require_relative './ext/pg_array'
Dir["#{ __dir__ }/noteshare/**/*.rb"].each { |file| require_relative file }

Lotus::Model.configure do
  ##
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/noteshare_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/noteshare_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/noteshare_development'
  #    adapter type: :sql, uri: 'mysql://localhost/noteshare_development'
  #
  adapter type: :sql, uri: ENV['NOTESHARE_DATABASE_URL']

  ##
  # Migrations
  #
  migrations 'db/migrations'
  schema     'db/schema.sql'

  ##
  # Database mapping
  #
  # Intended for specifying application wide mappings.
  #
  # You can specify mapping file to load with:
  #
  # mapping "#{__dir__}/config/mapping"
  #
  # Alternatively, you can use a block syntax like the following:
  #
  mapping do
    # ...
    collection :documents do
      entity     NSDocument
      repository DocumentRepository
      attribute :id,   Integer
      attribute :author, String
      attribute :title, String
      attribute :tags, String
      attribute :type, String
      attribute :area, String
      attribute :meta, JSON
      attribute :created_at, DateTime
      attribute :modified_at, DateTime
      attribute :content, String
      attribute :rendered_content, String
      attribute :compiled_and_rendered_content, String
      attribute :render_options, JSON
      attribute :parent_id, Integer
      attribute :author_id, Integer
      attribute :index_in_parent, Integer
      attribute :root_document_id, Integer
      attribute :visibility, Integer
      attribute :subdoc_refs, PGIntArray
      attribute :doc_refs, JSON
      attribute :toc, JSON
    end
  end
end.load!



Lotus::Mailer.configure do
  root "#{ __dir__ }/noteshare/mailers"

  # See http://lotusrb.org/guides/mailers/delivery
  delivery do
    development :test
    test        :test
    # production :stmp, address: ENV['SMTP_PORT'], port: 1025
  end
end.load!
