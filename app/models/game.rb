class Game < ActiveRecord::Base
  has_many :game_outcomes, :class_name => "GameOutcome"
  has_many :players, :through => :game_outcomes

  before_create :update_ranks

  def self.today
    where(:created_at => (Date.today + 0.hours)..(Date.today + 23.hours + 59.minutes))
  end

  def winners
    ( game_outcomes.select { | outcome | outcome.win } ).collect { | outcome | outcome.player }
  end

  def losers
    ( game_outcomes.select { | outcome | outcome.loss } ).collect { | outcome | outcome.player }
  end

  private

  def update_ranks
    winner = players.first
    loser  = players.last
    winner.wins!(loser, loser_score)
    loser.loses!(winner, loser_score)
  end
end
