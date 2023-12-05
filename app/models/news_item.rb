# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  ISSUES_LIST = ['Free Speech', 'Immigration', 'Terrorism', "Social Security and
  Medicare", 'Abortion', 'Student Loans', 'Gun Control', 'Unemployment',
                 'Climate Change', 'Homelessness', 'Racism', 'Tax Reform', "Net
  Neutrality", 'Religious Freedom', 'Border Security', 'Minimum Wage',
                 'Equal Pay'].freeze

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def self.get_articles(rep_name, issue)
    url = 'https://newsapi.org/v2/everything?' +
      'q=#{rep_name} AND #{issue}&' +
      'pageSize=5&' +
      'sort_by=relevancy&'
      'apiKey=#{Rails.application.credentials[:NEWS_API_KEY]}'

    response = Faraday.get(url)
    json = JSON.parse(response.body)
    articles = json['articles']
  end

  validates :issue, presence: true, inclusion: { in: ISSUES_LIST }
end
