class Outcome < ActiveRecord::Base
  belongs_to :game, :class_name => "Game"
  belongs_to :player, :class_name => "Player"

  def loss
    !self.win
  end

  def self.singles_outcomes
    self.where(:game_id => Outcome.select("game_id").group("game_id").having("count(*) < ?", 4))
  end

  def self.doubles_outcomes
    self.where(:game_id => Outcome.select("game_id").group("game_id").having("count(*) > ?", 3))

  end

  def self.singles_wins
    singles_outcomes.select { |outcome| outcome.win }
  end

  def self.singles_losses
    singles_outcomes.select { |outcome| !outcome.win }
  end

  def self.doubles_wins
    doubles_outcomes.select { |outcome| outcome.win }
  end

  def self.doubles_losses
    doubles_outcomes.select { |outcome| !outcome.win }
  end

end
