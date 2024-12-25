class Tag < ApplicationRecord
  has_many :tag_paths, dependent: :destroy
  has_many :posts, through: :tag_paths
  validates :title, presence: true, uniqueness: true
end
