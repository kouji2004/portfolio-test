class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

# バリデーション機能
  validates :title,length: { maximum: 7 },presence: true
  validates :body,length: { maximum: 150 },presence: true
  validates :prevention,length: { maximum: 150 },presence: true
  validates :images, presence: true

    # コメント機能
      has_many :comments, dependent: :destroy

    # いいね機能
      has_many :favorites, dependent: :destroy

    # 投稿いいね一覧
      has_many :favorite_users, through: :favorites, source: :user

    # 複数の写真で使う
      has_many_attached :images

        # 検索タグ
        scope :on_category, ->(category){where(category_id: category)}
        def get_image
          unless image.attached?
           file_path = Rails.root.join('app/assets/images/no_image.jpg')
           image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
          end
           image
        end

          #ユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べる
          def favorited_by?(user)
            favorites.exists?(user_id: user.id)
          end

            # 検索方法分岐 検索タグ　時に使用
            def self.looks(search, word)
              @post = Post.where("title LIKE?","%#{word}%")
              @post = Post.where("body LIKE?","%#{word}%")
            end

              def get_image
                unless images.attached?
                  file_path = Rails.root.join('app/assets/images/no_image.jpg')
                  image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
                end
                 images
              end

end
