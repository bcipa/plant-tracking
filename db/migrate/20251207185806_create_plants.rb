class CreatePlants < ActiveRecord::Migration[8.1]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :species
      t.date :purchased_at
      t.date :died_at

      t.timestamps
    end
  end
end
