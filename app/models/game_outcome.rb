class GameOutcome < ActiveRecord::Base
  belongs_to :game, :class_name => "Game"
  belongs_to :player, :class_name => "Player"

  def loss
    !self.win
  end
end
