require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:article) { create(:article, user: user) }

  describe "GET #index" do
    it "affiche tous les articles" do
      get :index
      expect(response).to be_successful
    end

    it "utilise le cache pour les articles" do
      expect(Rails.cache).to receive(:fetch).with("articles_list", expires_in: 5.minutes)
      get :index
    end
  end

  describe "GET #show" do
    it "affiche l'article demandé" do
      get :show, params: { id: article.id }
      expect(response).to be_successful
    end

    it "utilise le cache pour l'article" do
      expect(Rails.cache).to receive(:fetch).with("article_#{article.id}", expires_in: 1.hour)
      get :show, params: { id: article.id }
    end
  end

  describe "GET #new" do
    context "utilisateur connecté" do
      before { sign_in user }

      it "affiche le formulaire de création" do
        get :new
        expect(response).to be_successful
      end
    end

    context "utilisateur non connecté" do
      it "redirige vers la page de connexion" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "utilisateur connecté" do
      before { sign_in user }

      context "avec des paramètres valides" do
        it "crée un nouvel article" do
          expect {
            post :create, params: { article: attributes_for(:article) }
          }.to change(Article, :count).by(1)
        end

        it "invalide le cache des articles" do
          expect(Rails.cache).to receive(:delete).with("articles_list")
          post :create, params: { article: attributes_for(:article) }
        end
      end

      context "avec des paramètres invalides" do
        it "ne crée pas d'article" do
          expect {
            post :create, params: { article: attributes_for(:article, title: nil) }
          }.not_to change(Article, :count)
        end
      end
    end
  end

  describe "PUT #update" do
    context "propriétaire de l'article" do
      before { sign_in user }

      it "met à jour l'article" do
        put :update, params: { id: article.id, article: { title: "Nouveau titre" } }
        expect(article.reload.title).to eq("Nouveau titre")
      end

      it "invalide le cache des articles" do
        expect(Rails.cache).to receive(:delete).with("articles_list")
        put :update, params: { id: article.id, article: { title: "Nouveau titre" } }
      end
    end

    context "non propriétaire de l'article" do
      before { sign_in other_user }

      it "ne met pas à jour l'article" do
        put :update, params: { id: article.id, article: { title: "Nouveau titre" } }
        expect(article.reload.title).not_to eq("Nouveau titre")
      end
    end
  end

  describe "DELETE #destroy" do
    context "propriétaire de l'article" do
      before { sign_in user }

      it "supprime l'article" do
        article # créer l'article
        expect {
          delete :destroy, params: { id: article.id }
        }.to change(Article, :count).by(-1)
      end

      it "invalide le cache des articles" do
        expect(Rails.cache).to receive(:delete).with("articles_list")
        delete :destroy, params: { id: article.id }
      end
    end

    context "non propriétaire de l'article" do
      before { sign_in other_user }

      it "ne supprime pas l'article" do
        article # créer l'article
        expect {
          delete :destroy, params: { id: article.id }
        }.not_to change(Article, :count)
      end
    end
  end
end 