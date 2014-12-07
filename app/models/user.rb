class User < ActiveRecord::Base

	# =========================================================================
	# Pseudo Attributes 
	# =========================================================================	
	attr_accessor :remember_token 
	attr_accessor :password_confirmation
	attr_accessor :activation_token 
	attr_accessor :reset_token 
	# =========================================================================

	# =========================================================================
	# Associations 
	# =========================================================================
	has_many :user_groups 
	has_many :relationships 
	has_many :pending_relationships, -> { where(relationships: { status: :pending }) },
	         :through => :relationships, :source => :relationship
	# =========================================================================

	before_save :downcase_email 
	before_create :create_activation_digest 

	# =========================================================================
	# Validation
	# =========================================================================	
	validates :password, presence: true,
						 length: { minimum: 8 }
	validates_confirmation_of :password 
	validates :firstname, presence: true 
	validates :lastname,  presence: true 
	validates :username, presence: true,
						 length: { minimum: 5, maximum: 30 },
						 uniqueness: true
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
	          uniqueness: { case_sensitive: false }, 
	          presence: true

	has_secure_password
	# =========================================================================

	# =========================================================================
	# Helper methods 
	# =========================================================================
	
	def password_reset_expired?
		reset_sent_at < 2.hours.ago 
	end 

	# Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
    	SecureRandom.urlsafe_base64
    end

    def remember
    	self.remember_token = User.new_token  
    	update_attribute(:remember_digest, User.digest(remember_token))
    end 

    # returns true if the given token matches the digest
    def authenticated?(attribute, token)
    	digest = send("#{attribute}_digest")
    	return false if digest.nil?
    	BCrypt::Password.new(digest).is_password?(token)
    end

    def forget 
    	update_attribute(:remember_digest, nil)
    end 

    def downcase_email
    	self.email = email.downcase 
    end

    def activate 
    	update_attribute(:activated, true)
    	update_attribute(:activated_at, Time.zone.now)
    	UserGroup.insert_new(self, "Friends")
    	UserGroup.insert_new(self, "Family")
    end

    def send_activation_email
    	UserMailer.account_activation(self).deliver_now 
    end

    def create_activation_digest
    	self.activation_token = User.new_token 
    	self.activation_digest = User.digest(activation_token)
    end 

    def create_reset_digest 
    	self.reset_token = User.new_token 
    	update_attribute(:reset_digest, User.digest(reset_token))
    	update_attribute(:reset_sent_at, Time.zone.now)
    end 

    def send_password_reset_email
    	UserMailer.password_reset(self).deliver_now 
    end 
    # =========================================================================

end
