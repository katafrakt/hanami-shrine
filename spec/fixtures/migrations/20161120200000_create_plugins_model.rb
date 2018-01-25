Hanami::Model.migration do
  change do
    create_table :plugins_models do
      primary_key :id
      column :image_data, String, size: 1000
    end
  end
end
