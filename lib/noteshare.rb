require 'lotus/model'
require 'lotus/mailer'

require_relative './ext/pg_array'
require_relative './ext/pg_hstore'

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
      entity     Noteshare::Core::Document::NSDocument
      repository Noteshare::Core::Document::DocumentRepository
      attribute :id,   Integer
      attribute :title, String
      attribute :identifier, String

      attribute :author_identifier, String
      attribute :author_id, Integer
      attribute :author, String
      attribute :author_credentials, JSON

      attribute :tags, String
      attribute :type, String
      attribute :area, String
      attribute :meta, JSON

      attribute :created_at, DateTime
      attribute :updated_at, DateTime

      attribute :content, String
      attribute :content_stash, String
      attribute :compiled_content, String
      attribute :rendered_content, String
      attribute :compiled_and_rendered_content, String
      attribute :render_options, JSON

      attribute :parent_id, Integer
      attribute :parent_ref, JSON
      attribute :root_ref, JSON

      attribute :author_identifier, String
      attribute :index_in_parent, Integer
      attribute :root_document_id, Integer
      attribute :visibility, Integer
      attribute :subdoc_refs, PGIntArray
      attribute :doc_refs, JSON
      attribute :doc_refs2, JSON
      attribute :toc, JSON
      attribute :content_dirty, Boolean
      attribute :compiled_dirty, Boolean
      attribute :toc_dirty, Boolean
      attribute :acl, PGHStore
      attribute :groups_json, JSON
      attribute :xattributes, PGStringArray
      attribute :dict, PGHStore

      attribute :author_credentials2, PGHStore
    end

    collection :settings do
      entity     Settings
      repository SettingsRepository
      attribute :id,   Integer
      attribute :owner, String
      attribute :dict, PGHStore
    end

    collection :ns_users do
      entity User
      repository UserRepository
      attribute :id, Integer
      attribute :admin, Boolean
      attribute :first_name, String
      attribute :last_name, String
      attribute :identifier, String
      attribute :email, String
      attribute :screen_name, String
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :level, Integer
      attribute :password, String
      attribute :meta, JSON
      attribute :dict2, PGHStore
      attribute :groups, PGStringArray
      attribute :docs_visited, JSON
      attribute :nodes_visited, JSON
      attribute :images_visited, JSON
    end


    collection :nodes do
      entity Noteshare::Core::Node::NSNode
      repository NSNodeRepository
      attribute :id, Integer
      attribute :owner_id, Integer
      attribute :identifier, String
      attribute :name, String
      attribute :type, String
      attribute :meta, JSON
      attribute :docs, JSON
      attribute :children, JSON
      attribute :tags, String
      attribute :xattributes, PGStringArray
      attribute :dict, PGHStore
      attribute :neighbors, JSON
    end

    collection :publications do
      entity Publications
      repository PublicationsRepository
      attribute :id, Integer
      attribute :node_id, Integer
      attribute :document_id, Integer
      attribute :type, String
    end

    collection :ns_groups do
      entity Groups
      repository GroupsRepository
      attribute :id, Integer
      attribute :owner_id, Integer
      attribute :name, String
    end

    collection :ns_images do
      entity Image
      repository ImageRepository
      attribute :id, Integer
      attribute :owner_id, Integer, as: :owner
      attribute :title, String
      attribute :file_name, String, as: :data_file_name
      attribute :mime_type, String, as: :data_content_type
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :public, Boolean
      attribute :dict, PGHStore
      attribute :doc_ids, PGIntArray
      attribute :tags, String
      attribute :identifier, String
      attribute :url, String
      attribute :source, String
    end


    collection :courses do
      entity     Course
      repository CourseRepository

      attribute :id,    Integer
      attribute :title, String
      attribute :author_id, Integer, as: :author
      attribute :tags, String
      attribute :area, String
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :content, String, as: :description
      attribute :course_attributes, String

    end

    collection :lessons do
      entity     Lesson
      repository LessonRepository

      attribute :id,    Integer
      attribute :title, String
      attribute :author_id, Integer
      attribute :tags, String
      attribute :area, String
      attribute :course_id, Integer
      attribute :content, String,  as: :original_content
      attribute :sequence, Integer
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :summary, String, as: :capsule
      attribute :aside, String, as: :original_aside
      attribute :image_path1, String
      attribute :image_path2, String
      attribute :content_type, String


    end

    collection :commands2 do
      entity Command
      repository CommandRepository

      attribute :token, String
      attribute :command_verb, String
      attribute :args, PGStringArray
      attribute :created_at, DateTime
      attribute :expires_at, DateTime
      attribute :next_token, String

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
