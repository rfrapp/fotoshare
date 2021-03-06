class User < ActiveRecord::Base

  # =========================================================================
  # Pseudo Attributes 
  # =========================================================================	
  attr_accessor :remember_token 
  attr_accessor :password_confirmation
  attr_accessor :activation_token 
  attr_accessor :reset_token 
  attr_accessor :name 
  # =========================================================================

  # =========================================================================
  # Associations 
  # =========================================================================
  has_many :albums, dependent: :destroy
  has_many :user_groups 
  has_many :relationships, -> { where(relationships: { status: :accept }) }
  has_many :inverse_relationships, -> { where(relationships: { status: :accept }) },
  :class_name => "Relationship", :foreign_key => :other_user_id 

  has_many :pending_relationships, -> { where(relationships: { status: :pending }) } ,
  :class_name => "Relationship"
  has_many :inverse_pending_relationships, -> { where(relationships: { status: :pending }) } ,
  :class_name => "Relationship", :foreign_key => :other_user_id
  # has_many :pending_relationships, -> { where(relationships: { status: :pending });
  # 		 order('UserGroup.name DESC') },
  #          :through => :relationships, :source => :relationship
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
  # Gettters and setters
  # =========================================================================
  def name
    @name = self.firstname + " " + self.lastname 
  end 
  # =========================================================================

  # =========================================================================
  # Helper methods 
  # =========================================================================

  # Feed
  def feed
    @group = UserGroup.find_by(user_id: id, name: "friends")
    @group_members = @user.relationships.where(user_id: id, 
                                               group_id: @group.id)
    ids ||= []
    @group_members.each { ids << |x|.id }
    ids << id
    Picture.where("album_id = ?", Album.where("user_id = ?", User.find_all_by_id(ids)).id)
  end
  
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
    UserGroup.insert_new(self, "Blocked Users")
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
