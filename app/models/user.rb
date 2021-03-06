class User < ActiveRecord::Base

	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship",
						dependent: :destroy
	has_many :followers, through: :reverse_relationships
	has_many :received_messages, class_name: "Message", foreign_key: "receiver_id" ,dependent: :destroy
	has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy

	has_secure_password

	before_save { self.email = email.downcase }
	before_create :create_remember_token

	validates :name, presence: true, length: {maximum: 50}
	validates :password, length: { minimum: 6 }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
				uniqueness: { case_sensitive: false }

				
  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
  	relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
  	relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
  	relationships.find_by(followed_id: other_user.id).destroy
  end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1::hexdigest(token.to_s)
	end

	def admin?
		self.admin
	end

	def send_password_reset
    self.password_reset_token = User.encrypt(User.new_remember_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
