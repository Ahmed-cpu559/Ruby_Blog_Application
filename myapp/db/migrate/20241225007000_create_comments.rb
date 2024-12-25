# db/migrate/YYYYMMDDHHMMSS_create_comments.rb
class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: { to_table: :posts } 
      t.references :user, null: false, foreign_key: { to_table: :users } 
      t.text :body

      t.timestamps
    end
  end
end