Lotus::Model.migration do
  change do
    create_table :documents do
      primary_key :id
      index :identifier, String,   unique: true
      column :author,     String,   null: false
      column :title,      String,   null: false
      column :tags,       String
      column :meta,       String
      column :createdAt,  DateTime
      column :modifiedAt, DateTime
      column :text,       String
      column :parts,      String
    end
  end
end
