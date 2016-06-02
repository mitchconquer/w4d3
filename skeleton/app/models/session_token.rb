require 'securerandom'

class SessionToken < ActiveRecord::Base
  validates :user_id, :login_ip, :device, :token, presence: true
  before_validation :ensure_session_token

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

    def reset_session_token!
      self.token = SecureRandom.base64
      self.save!
      self.token
    end

    def self.exists?(user, device)
      self.find_by(user_id: user.id, device: device)
    end






    def ensure_session_token
      self.token ||= SecureRandom.base64
    end

end
