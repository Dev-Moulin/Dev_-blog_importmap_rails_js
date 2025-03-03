require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { create(:user) }
  let(:article) { build(:article, user: user) }

  describe "validations" do
    it "est valide avec des attributs valides" do
      expect(article).to be_valid
    end

    it "n'est pas valide sans titre" do
      article.title = nil
      expect(article).not_to be_valid
    end

    it "n'est pas valide sans contenu" do
      article.content = nil
      expect(article).not_to be_valid
    end

    it "n'est pas valide sans utilisateur" do
      article.user = nil
      expect(article).not_to be_valid
    end
  end

  describe "associations" do
    it "appartient à un utilisateur" do
      expect(Article.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  describe "comportement" do
    it "utilise l'email de l'utilisateur comme auteur" do
      article.save
      expect(article.author).to eq(user.email)
    end
  end
end
