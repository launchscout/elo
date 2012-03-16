class AddLeagueIdToGame < ActiveRecord::Migration
  def change
    add_column :games, :league_id, :integer
    add_index :games, :league_id
  end
end
