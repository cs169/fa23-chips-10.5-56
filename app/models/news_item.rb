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

  def rating
    Rails.logger.debug '77777777777777777777777777777777777777'
    Rails.logger.debug rating_sum
    return nil if ratings.size.zero?

    rating_sum / ratings.size.to_f
  end

  # returns list of (up to) five articles that match params
  def self.get_articles(rep_name, issue)
    q_param = "#{rep_name}  #{issue}"
    uri = 'https://newsapi.org/v2/everything?' \
          "q=#{CGI.escape(q_param)}&" \
          'pageSize=5&' \
          'sortBy=relevancy&' \
          "apiKey=#{Rails.application.credentials[:NEWS_API_KEY]}"

    response = Faraday.get(uri)
    json = JSON.parse(response.body)
    all_articles = json['articles']

    Rails.logger.debug { "22222222#{all_articles.length}" }

    articles_list = []
    num_articles = all_articles.length
    # adds article hash to list of articles
    num_articles.times do |index|
      article = all_articles[index]
      article_hash = {
        title:       article['title'],
        url:         article['url'],
        description: article['description']
      }
      articles_list[index] = article_hash
    end
    articles_list
  end

  validates :issue, presence: true, inclusion: { in: ISSUES_LIST }
end
