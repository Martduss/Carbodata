class Post < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_one_attached :photo

  multisearchable against: [:title, :content]

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 5000 }

  # Calcule le score total du post (upvotes - downvotes)
  def score
    votes.sum(:value)
  end

  # Trouve le vote d'un utilisateur spécifique sur ce post
  def vote_by(user)
    votes.find_by(user: user)
  end
end
