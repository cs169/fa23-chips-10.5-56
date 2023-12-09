# frozen_string_literal: true

class AddRatingSumToNewsItems < ActiveRecord::Migration[5.2]
  def change
    add_column :news_items, :rating_sum, :integer
  end
end
