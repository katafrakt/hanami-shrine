Hanami::Model.migration do
  change do
    create_table :kittens do
      primary_key :id
      column :title, String
      column :image_data, String
    end
  end
end
