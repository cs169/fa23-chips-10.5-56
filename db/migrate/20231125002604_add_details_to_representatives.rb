# frozen_string_literal: true

class AddDetailsToRepresentatives < ActiveRecord::Migration[5.2]
  def change
    add_column :representatives, :address1, :string
    add_column :representatives, :address2, :string
    add_column :representatives, :string, :string
    add_column :representatives, :city, :string
    add_column :representatives, :state, :string
    add_column :representatives, :zip, :string
    add_column :representatives, :party, :string
    add_column :representatives, :photo, :string
  end
end
