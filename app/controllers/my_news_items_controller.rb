# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :set_issues_list, only: [:new, :edit, :create, :update]

  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def create
    @news_item = NewsItem.new(news_item_params)
  
    if @news_item.save
      flash[:notice] = 'News item was successfully created.'
      redirect_to some_path(@news_item.representative, issue: @news_item.issue)
    else
      @representative = Representative.find_by(id: news_item_params[:representative_id])
      @issue = news_item_params[:issue]
      flash.now[:error] = 'An error occurred when creating the news item.'
      render :new
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
    representative_id = params[:news_item][:representative_id]
    @issue = params[:news_item][:issue]

    if representative_id.present? && @issue
      @representative = Representative.find(representative_id)
      @articles = NewsItem.get_articles(@representative.name, @issue)
    end
  end

  # TODO: save selected news article to database
  def save
    selected_index = params[:news_item][:selected_article].to_i
    article = @articles[selected_index]
  
    @news_item = NewsItem.new(
      title: article[:title],
      link: article[:url],
      description: article[:description],
      representative_id: params[:news_item][:representative_id],
      issue: params[:news_item][:issue]
    )
  end

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
