# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :set_issues_list

  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def create
    puts
    @news_item = NewsItem.new(
      title:             params[:title],
      link:              params[:link],
      description:       params[:description],
      issue:             params[:issue],
      representative_id: @representative.id
    )
    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully created.'
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  def update
    if @news_item.update(news_item_params)
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully updated.'
    else
      render :edit, error: 'An error occurred when updating the news item.'
    end
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative),
                notice: 'News was successfully destroyed.'
  end

  # sets selected rep and issue from view 1
  # queries articles
  def search
    @news_item = NewsItem.new
    @representative = Representative.find(params[:representative_id])
    @issue = params[:issue]
    @articles = NewsItem.get_articles(@representative.name, @issue)

    @news_items = @articles.map do |article|
      NewsItem.new do |news|
        news.title = article[:title]
        news.link = article[:url]
        news.description = article[:description]
        news.representative_id = @representative.id
        news.issue = @issue
      end
    end

    return unless @news_items.empty?

    flash.now[:error] = 'No news items available related to this issue'
    render :new
  end

  # TODO: save selected news article to database
  def save; end

  private

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  def set_issues_list
    @issues_list = NewsItem::ISSUES_LIST
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue)
  end
end
