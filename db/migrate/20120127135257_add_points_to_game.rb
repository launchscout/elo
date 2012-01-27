class AddPointsToGame < ActiveRecord::Migration
  def change 
    add_column :games, :loser_score, :integer, :default => 0
    add_column :doubles_games, :loser_score, :integer, :default => 0
  end
end
