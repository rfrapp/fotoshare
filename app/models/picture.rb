class Picture < ActiveRecord::Base

  #============================================================================
  # Associations
  #============================================================================
  belongs_to :album
  mount_uploader :location, PictureUploader

  #============================================================================
  # Lambdas
  #============================================================================
  default_scope -> { order(created_at: :desc) } # Retreive in LIFO order

  #============================================================================
  # Validations
  #============================================================================
  validates :album_id, presence: true
  validates :location, presence: true
  validate :location_size

  private

  def location_size
    if location.size > 5.megabytes
      errors.add(:location, "should be less than 5MB")
    end
  end
end
