Hanami::Model.migration do
  change do
    create_table :multi_cats do
      primary_key :id
      column :title, String
      column :cat1_data, String
      column :cat2_data, String
    end
  end
end
