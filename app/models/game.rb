class Game < ActiveRecord::Base
  belongs_to :winner, :class_name => "Player"
  belongs_to :loser, :class_name => "Player"

  before_create :update_ranks
  
  private

  def update_ranks
    winner.wins!(loser)
    loser.loses!(winner)
  end
end
