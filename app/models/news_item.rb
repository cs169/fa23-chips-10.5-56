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

  # returns list of five articles that match params
  def self.get_articles(rep_name, issue)
    # stubbing articles
    articles = [{title: '0', url: '00000.com', description: 'world0'}, {title: '1', url: '1111.com', description: 'world1'}, {title: '2', url: '2222.com', description: '2'}, {title: '3', url: '33333.com', description: 'world3'},  {title: '4', url: '44444.com', description: 'world4'},]
    articles
    return
    uri = 'https://newsapi.org/v2/everything?' +
          "q=#{rep_name} AND #{issue}&" +
          "pageSize=5&" +
          "sort_by=relevancy&" +
          "apiKey=#{Rails.application.credentials[:NEWS_API_KEY]}"

    response = Faraday.get(uri)
    json = JSON.parse(response.body)
    articles = json['articles']
  end

  validates :issue, presence: true, inclusion: { in: ISSUES_LIST }
end
