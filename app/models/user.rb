class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_one_attached :photo

  scope :demo, -> { where(demo: true) }

  attr_accessor :accept_terms

  validates :accept_terms, acceptance: true, on: :create

  before_create :set_accepted_terms_at, if: :accept_terms

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def set_accepted_terms_at
    self.accepted_terms_at = Time.current
  end
end
