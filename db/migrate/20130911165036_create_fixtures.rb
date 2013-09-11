class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.string :next_match_team
      t.string :next_match_time
      t.string :last_match_team
      t.string :last_match_result
      t.integer :team_id
      t.timestamps
    end
  end
end
