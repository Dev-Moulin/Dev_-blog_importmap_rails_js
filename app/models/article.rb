class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true

  before_validation :set_author

  private

  def set_author
    self.author = user.email if user
  end
end
