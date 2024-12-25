# db/migrate/YYYYMMDDHHMMSS_create_tag_paths.rb
class CreateTagPaths < ActiveRecord::Migration[8.0]
  def change
    create_table :tag_paths do |t|
      t.references :post, null: false, foreign_key: { to_table: :posts } 
      t.references :tag, null: false, foreign_key: { to_table: :tags } 

      t.timestamps
    end
  end
end