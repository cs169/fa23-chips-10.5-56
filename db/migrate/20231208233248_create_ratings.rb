# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer :score
      t.integer :user_id
      t.integer :news_item_id

      t.index :news_item_id, name: 'index_ratings_on_news_item_id'
      t.index :user_id, name: 'index_ratings_on_user_id'
    end
  end
end
