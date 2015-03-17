class User < ActiveRecord::Base
  has_many :reviews
  has_secure_password validations: false

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}

end
