# frozen_string_literal: true
require 'uri'

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

  # returns list of (up to) five articles that match params (sorted by relevancy)
  def self.get_articles(rep_name, issue)
    q_param = "#{rep_name} AND #{issue}"
    uri = "https://newsapi.org/v2/everything?" +
          "q=#{URI.encode(q_param)}&" +
          "pageSize=5&" +
          "sortBy=relevancy&" +
          "apiKey=#{Rails.application.credentials[:NEWS_API_KEY]}"

    # stubbing
    #response = '{"status":"ok","totalResults":32,"articles":[{"source":{"id":null,"name":"The Atlantic"},"author":"McKay Coppins","title":"Loyalists, Lapdogs, and Cronies","description":"In a second Trump term, there would be no adults in the room.","url":"https://www.theatlantic.com/magazine/archive/2024/01/donald-trump-2024-reelection-cabinet-appointments/676121/?utm_source=feed","urlToImage":null,"publishedAt":"2023-12-04T10:59:00Z","content":"Editor’s Note: This article is part of “If Trump Wins,” a project considering what Donald Trump might do if reelected in 2024. When Donald Trump first took office, he put a premium on what he called … [+8329 chars]"},{"source":{"id":"msnbc","name":"MSNBC"},"author":"Steve Benen","title":"Accused of targeting democracy, Trump turns to ‘no puppet’ tactics","description":"Ted Cruz once said of Donald Trump, \"Whatever he does, he accuses everyone else of doing.” More than seven years later, the quote remains highly relevant.","url":"https://www.msnbc.com/rachel-maddow-show/maddowblog/accused-targeting-democracy-trump-turns-no-puppet-tactics-rcna127904","urlToImage":"https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2023-12/231204-donald-trump-se-1014a-6b2311.jpg","publishedAt":"2023-12-04T15:59:05Z","content":"A New York Times report noted over the weekend that Donald Trump and his allies have embraced a post-2024 vision that would upend core elements of American governance, democracy, foreign policy and t… [+4454 chars]"},{"source":{"id":null,"name":"The New Republic"},"author":"Grace Segers","title":"Mike Johnson Repeats Kevin McCarthy’s Mistake: Trying to Govern","description":"House Speaker Mike Johnson’s honeymoon period lasted about as long as an actual honeymoon: a few weeks, at best. Now that Congress has punted its most intransigent problem—keeping the government funded—to early next year, Johnson must shepherd several other c…","url":"https://newrepublic.com/article/177235/mike-johnson-repeats-kevin-mccarthys-mistake-trying-govern","urlToImage":"https://images.newrepublic.com/dd2371a8d613ee3871f532b314b9cfb304dfcd10.jpeg?w=1200&h=630&crop=faces&fit=crop&fm=jpg","publishedAt":"2023-12-01T11:00:00Z","content":"Santos, who also faces a litany of federal charges, has vociferously denied any wrongdoing and has refused to step down. He is likely to become only the sixth lawmaker to ever be expelled from the Ho… [+1111 chars]"},{"source":{"id":"breitbart-news","name":"Breitbart News"},"author":"Nick Gilbertson, Nick Gilbertson","title":"Exclusive: American Leadership PAC Unveils Radio Ad Touting Indiana's Jim Banks as ‘True Conservative’ on Illegal Immigration","description":"A PAC backing Rep. Jim Banks (R-IN) in his Senate bid shared with Breitbart News its latest radio ad supporting the candidate.","url":"https://www.breitbart.com/2024-election/2023/11/08/exclusive-american-leadership-pac-unveils-radio-ad-touting-indianas-jim-banks-true-conservative-illegal-immigration/","urlToImage":"https://media.breitbart.com/media/2021/03/138561074_2476865625941929_8178191794353059851_n-640x335.jpg","publishedAt":"2023-11-08T17:14:47Z","content":"A super PAC backing Rep. Jim Banks (R-IN) in his Senate bid has exclusively shared with Breitbart News its latest radio ad in support of Banks ahead of its release. \r\nThe advertisement from the Ameri… [+2314 chars]"},{"source":{"id":null,"name":"The Daily Caller"},"author":"Katelynn Richardson","title":"Biden Needs To Speed Judicial Confirmations To Match Trump’s Pace In Federal Appointments","description":"The Senate confirmed President Joe Biden&#039;s 150th federal judicial nominee on Tuesday, meaning 37 more nominees must be confirmed by the end of the year for him to match Trump&#039;s pace.","url":"https://dailycaller.com/2023/11/08/biden-speed-judicial-confirmations-match-trumps-pace-federal-appointments/","urlToImage":"https://cdn01.dailycaller.com/wp-content/uploads/2023/10/GettyImages-1745421164-scaled-e1698343125493.jpg","publishedAt":"2023-11-08T15:34:44Z","content":"The Senate confirmed President Joe Biden’s 150th federal judicial nominee on Tuesday, meaning 37 more nominees must be confirmed by the end of the year for him to match former President Donald Trump’… [+3469 chars]"}]}'
    response = Faraday.get(uri)
    json = JSON.parse(response.body)
    json = JSON.parse(response.body)
    all_articles = json["articles"]

    articles_list = []
    num_articles = [5, all_articles.length].min

    # adds article hash to list of articles
    num_articles.times do |index|
      article = all_articles[index]
      article_hash = {
        title: article["title"],
        url: article["url"],
        description: article["description"]
      }
      articles_list[index] = article_hash
    end

    articles_list
  end

  validates :issue, presence: true, inclusion: { in: ISSUES_LIST }
end
