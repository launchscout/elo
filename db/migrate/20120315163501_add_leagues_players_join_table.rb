class AddLeaguesPlayersJoinTable < ActiveRecord::Migration
  def up
    create_table :leagues_players, :id => false do |t|
      t.references :league
      t.references :player
    end
    add_index :leagues_players, [:league_id, :player_id]
    add_index :leagues_players, [:player_id, :league_id]
  end

  def down
    drop_table :leagues_players
  end
end
