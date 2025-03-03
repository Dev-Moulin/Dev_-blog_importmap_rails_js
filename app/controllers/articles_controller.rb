class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :check_article_owner, only: [:edit, :update, :destroy]

  # GET /articles or /articles.json
  def index
    @articles = Rails.cache.fetch("articles_list", expires_in: 5.minutes) do
      Article.includes(:user).all.to_a
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
    fresh_when(@article)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = current_user.articles.build(article_params)

    respond_to do |format|
      if @article.save
        Rails.cache.delete("articles_list")
        format.html { redirect_to @article, notice: "L'article a été créé avec succès." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        Rails.cache.delete("articles_list")
        format.html { redirect_to @article, notice: "L'article a été mis à jour avec succès." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!
    Rails.cache.delete("articles_list")

    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "L'article a été supprimé avec succès." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Rails.cache.fetch("article_#{params[:id]}", expires_in: 1.hour) do
        Article.includes(:user).find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content)
    end

    def check_article_owner
      unless @article.user == current_user
        redirect_to articles_path, alert: "Vous n'êtes pas autorisé à modifier cet article."
      end
    end
end
