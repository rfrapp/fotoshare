class User < ActiveRecord::Base

	# =========================================================================
	# Pseudo Attributes 
	# =========================================================================	
	attr_accessor :remember_token 
	attr_accessor :password_confirmation
	# =========================================================================

	# =========================================================================
	# Associations 
	# =========================================================================
	has_many :relationships 
	has_many :relations, :through => :relationships 
	# =========================================================================

	before_save { self.email = email.downcase }

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
    def authenticated?(remember_token)
    	return false if remember_digest.nil?
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget 
    	update_attribute(:remember_digest, nil)
    end 
    # =========================================================================

end
