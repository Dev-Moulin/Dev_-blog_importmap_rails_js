require 'rails_helper'

RSpec.describe "Articles", type: :system do
  let(:user) { create(:user) }
  let!(:article) { create(:article, user: user) }

  describe "Liste des articles" do
    it "affiche tous les articles" do
      visit articles_path
      expect(page).to have_content(article.title)
      expect(page).to have_content(article.author)
    end

    it "affiche le bouton de création d'article" do
      visit articles_path
      expect(page).to have_link(nil, href: new_article_path)
    end
  end

  describe "Création d'article" do
    context "utilisateur connecté" do
      before do
        sign_in user
        visit new_article_path
      end

      it "crée un nouvel article avec des données valides" do
        fill_in "article[title]", with: "Mon nouvel article"
        fill_in "article[content]", with: "Le contenu de mon article"
        find('input[name="commit"]').click

        expect(page).to have_content("L'article a été créé avec succès")
        expect(page).to have_content("Mon nouvel article")
      end

      it "affiche les erreurs avec des données invalides" do
        find('input[name="commit"]').click
        expect(page).to have_content("Title can't be blank")
      end
    end

    context "utilisateur non connecté" do
      it "redirige vers la page de connexion" do
        visit new_article_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  describe "Modification d'article" do
    context "propriétaire de l'article" do
      before do
        sign_in user
        visit edit_article_path(article)
      end

      it "modifie l'article avec des données valides" do
        fill_in "article[title]", with: "Titre modifié"
        find('input[name="commit"]').click

        expect(page).to have_content("L'article a été mis à jour avec succès")
        expect(page).to have_content("Titre modifié")
      end
    end

    context "non propriétaire de l'article" do
      let(:other_user) { create(:user) }

      it "ne permet pas la modification" do
        sign_in other_user
        visit edit_article_path(article)
        expect(page).to have_current_path(articles_path)
        expect(page).to have_content("Vous n'êtes pas autorisé")
      end
    end
  end

  describe "Suppression d'article" do
    context "propriétaire de l'article" do
      before do
        sign_in user
        visit articles_path
      end

      it "supprime l'article" do
        click_button "Supprimer"

        expect(page).to have_content("L'article a été supprimé avec succès")
        expect(page).not_to have_content(article.title)
      end
    end
  end
end 