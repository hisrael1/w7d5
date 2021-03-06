#FIG VAPER
##########
class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  attr_reader :password

  after_initialize :ensure_session_token

  has_many :subs,
    foreign_key: :moderator_id,
    class_name: :Sub

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password) 
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password) 
  end

  def reset_session_token!
    #
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  

end
