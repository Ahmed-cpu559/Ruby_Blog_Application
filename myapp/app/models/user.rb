require 'jwt'

class User < ApplicationRecord

  before_save { self.email = email.downcase } # تحويل البريد الإلكتروني إلى أحرف صغيرة قبل الحفظ
  has_secure_password 
  
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  has_many :posts, foreign_key: 'author_id'
  has_many :comments
  def generate_jwt
    payload = {
      user_id: id,
      name: name, 
      email: email, 
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, "asd")
  end
end