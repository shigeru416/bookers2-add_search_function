class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  attachment :profile_image, destroy: false

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  #　ユーザーを検索
  def User.search(search, user_or_book, how_search)
    if user_or_book == "user"
      if how_search == "match"
        User.where(['name LIKE ?', "#{search}"])
      elsif how_search == "forward"
        User.where(['name LIKE ?', "#{search}%"])
      elsif how_search == "backward"
        User.where(['name LIKE ?', "%#{search}"])
      elsif how_search == "partial"
        User.where(['name LIKE ?', "%#{search}%"])
      else
        User.all
      end
    end
  end

  # 投稿を検索
  def Book.search(search, user_or_book, how_search)
    if user_or_book == "book"
      if how_search == "match"
        Book.where(['title LIKE ?', "#{search}"])
      elsif how_search == "forward"
        Book.where(['title LIKE ?', "#{search}%"])
      elsif how_search == "backward"
        Book.where(['title LIKE ?', "%#{search}"])
      elsif how_search == "partial"
        Book.where(['title LIKE ?', "%#{search}%"])
      else
        Book.all
      end
    end
  end

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}
end
