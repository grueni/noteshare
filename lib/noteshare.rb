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
  # Intended for specifying applica1ion wide mappings.
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
      attribute :modified_at, DateTime
      attribute :content, String
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
      attribute :toc, JSON
      attribute :content_dirty, Boolean
      attribute :compiled_dirty, Boolean
      attribute :toc_dirty, Boolean
      attribute :acl, JSON
      attribute :groups_json, JSON
    end

    collection :settings do
      entity     Settings
      repository SettingsRepository
      attribute :id,   Integer
      attribute :owner, String
    end

    collection :users do
      entity User
      repository UserRepository
      attribute :id, Integer
      attribute :admin, Boolean
      attribute :first_name, String
      attribute :last_name, String
      attribute :identifier, String
      attribute :email, String
      attribute :screen_name, String
      attribute :level, Integer
      attribute :password, String
      attribute :meta, JSON
      attribute :password_confirmation, String
    end


    collection :nodes do
      entity NSNode
      repository NSNodeRepository
      attribute :id, Integer
      attribute :owner_id, Integer
      attribute :identifier, String
      attribute :name, String
      attribute :type, String
      attribute :meta, JSON
      attribute :docs, JSON
      attribute :children, JSON
    end

    collection :images do
      entity Image
      repository ImageRepository
      attribute :id, Integer
      attribute :owner_id, Integer, as: :owner
      attribute :title, String
      attribute :file_name, String, as: :data_file_name
      attribute :mime_type, String, as: :data_content_type
      attribute :created_at, DateTime
      attribute :modified_at, DateTime, as: :updated_at
      attribute :public, Boolean
      attribute :meta, JSON
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
      attribute :modified_at, DateTime, as: :updated_at
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
      attribute :course_id, Integer
      attribute :content, String,  as: :original_content
      attribute :sequence, Integer
      attribute :created_at, DateTime
      attribute :modified_at, DateTime, as: :updated_at

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
