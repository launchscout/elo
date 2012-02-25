class ReallyTrackLastGame < ActiveRecord::Migration
  def change
    add_column :players, :last_game_id, :integer
  end
end
