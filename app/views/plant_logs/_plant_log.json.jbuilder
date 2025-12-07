json.extract! plant_log, :id, :plant_id, :watered, :image, :created_at, :updated_at
json.url plant_log_url(plant_log, format: :json)
