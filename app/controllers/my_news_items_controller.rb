# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :set_issues_list, only: %i[new edit create update]

  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def create
    @news_item = NewsItem.new(news_item_params)
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
  # renders view 2
  # searches for articles
  def search
    @representative = Representative.find(params[:news_item][:representative_id])
    @issue = params[:news_item][:issue]
    #@articles = [{title: 'article0', url: '00000.com', description: 'world0'}, {title: 'article1', url: '1111.com', description: 'world1'}, {title: 'article2', url: '2222.com', description: '2'}, {title: 'article3', url: '33333.com', description: 'world3'},  {title: 'article4', url: '44444.com', description: 'world4'}]
    @articles = NewsItem.get_articles(@representative.name, @issue)
    # render :search
  end

  # todo: save selected news article to database (2.4)
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
