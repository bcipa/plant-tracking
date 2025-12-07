class CreatePlantLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :plant_logs do |t|
      t.references :plant, null: false, foreign_key: true
      t.boolean :watered
      t.string :image

      t.timestamps
    end
  end
end
