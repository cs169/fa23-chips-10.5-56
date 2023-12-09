# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :news_item

  validate :score_not_changed

  after_create :update_news_item_ratings_sum

  private

  def update_news_item_ratings_sum
    Rails.logger.debug { "22222222222222#{score}" }
    news_item.update!(rating_sum: news_item.rating_sum.to_i + score.to_i)
  end

  def score_not_changed
    raise ActiveRecord::RecordInvalid if score_changed? && persisted?
  end
end
