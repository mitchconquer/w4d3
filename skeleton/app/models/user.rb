require 'securerandom'

class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  has_many :requests,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'CatRentalRequest'
    
  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'Cat'

  def reset_session_token!
    self.session_token = SecureRandom.base64
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end


  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    return nil unless user = User.find_by(user_name: user_name)
    return user if BCrypt::Password.new(user.password_digest).is_password?(password)
    nil
  end

  private
  def ensure_session_token
    self.session_token ||= SecureRandom.base64
  end
end
