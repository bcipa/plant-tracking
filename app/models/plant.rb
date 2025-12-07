class Plant < ApplicationRecord
  has_many :plant_logs, dependent: :destroy
  # has_one_attached :profile_picture

  def profile_picture
    plant_logs.order(created_at: :desc).first&.image
  end

  def last_watered_at
    last_log = plant_logs.where(watered: true).order(created_at: :desc).first
    last_log&.created_at
  end
end
