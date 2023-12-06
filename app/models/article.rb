class Article < ApplicationRecord
  has_many :ratings

  # validating tile, description, link
  validates :title, presence: true
  validates :description, presence: true
  validates :link, presence: true
end