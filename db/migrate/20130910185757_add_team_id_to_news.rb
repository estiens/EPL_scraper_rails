class AddTeamIdToNews < ActiveRecord::Migration
  def change
    add_column :news, :team_id, :integer
  end
end
