class MoveGameWinnersAndLosers < ActiveRecord::Migration

  class Game < ActiveRecord::Base
  end
  class Outcome < ActiveRecord::Base
  end

  def up
    Game.all.each do |game|
      Outcome.reset_column_information
      Outcome.create( :player_id => game.winner_id, :game_id => game.id, :win => 1 )

      Outcome.reset_column_information
      Outcome.create( :player_id => game.loser_id, :game_id => game.id, :win => 0 )
    end

    remove_column :games, :winner_id
    remove_column :games, :loser_id
  end

  def down
    add_column :games, :winner_id, :integer
    add_column :games, :loser_id, :integer

    Game.reset_column_information
    Outcome.all.each do |game_outcome|
      game = Game.find(game_outcome.game_id)
      if game_outcome.win
        game.winner_id = game_outcome.player_id
      else
        game.loser_id = game_outcome.player_id
      end
      game.save
    end
    Outcome.delete_all
  end
end
