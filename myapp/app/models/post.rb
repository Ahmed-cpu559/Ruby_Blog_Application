
class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :comments ,dependent: :destroy
  has_many :tag_paths, dependent: :destroy
  has_many :tags, through: :tag_paths
  validates :title, presence: true
  validates :body, presence: true
end