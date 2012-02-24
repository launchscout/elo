class PlayersDoubleRank < ActiveRecord::Migration
  class Player < ActiveRecord::Base
  end
  
  def up
    add_column :players, :doubles_rank, :integer
    Player.reset_column_information
    Player.all.each do |player|
      player.update_attributes(:doubles_rank => player.rank)
    end
  end

  def down
    remove_column :players, :doubles_rank
 end
end
