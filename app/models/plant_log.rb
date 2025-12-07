class PlantLog < ApplicationRecord
  belongs_to :plant
  has_one_attached :image

  after_commit :export_image, on: :create

  private

  def export_image
    ImageExporter.new(self).call
  end
end
