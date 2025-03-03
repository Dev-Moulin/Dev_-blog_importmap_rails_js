require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validations" do
    it "est valide avec des attributs valides" do
      expect(user).to be_valid
    end

    it "n'est pas valide sans email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "n'est pas valide avec un email invalide" do
      user.email = "invalid_email"
      expect(user).not_to be_valid
    end

    it "n'est pas valide sans mot de passe" do
      user.password = nil
      expect(user).not_to be_valid
    end

    it "n'est pas valide avec un mot de passe trop court" do
      user.password = "short"
      user.password_confirmation = "short"
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "a plusieurs articles" do
      expect(User.reflect_on_association(:articles).macro).to eq(:has_many)
    end

    it "supprime ses articles lors de sa suppression" do
      user.save
      create(:article, user: user)
      expect { user.destroy }.to change { Article.count }.by(-1)
    end
  end
end
