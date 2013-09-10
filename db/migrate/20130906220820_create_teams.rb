class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :games_won
      t.integer :games_lost 
      t.integer :games_drawn
      t.integer :goals_for 
      t.integer :goals_against 
      t.integer :points 
      t.text :description 
      t.timestamps
    end
  end
end
