class ArticlesController < ApplicationController

  def save_rating
    # Retrieve data to save
    selected_article = params[:selectedArticle]
    rating = params[:rating]

    # Save the selected article and rating to the database
    article = Article.find_by(title: selected_article)
    article.ratings.create(value: rating)

    # Redirect to a relevant page after saving
    redirect_to root_path, notice: 'Article rating saved successfully.'
  end
  
end