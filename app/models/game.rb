class Game < ActiveRecord::Base
  has_many :outcomes, :dependent => :destroy

  accepts_nested_attributes_for :outcomes

  after_create :update_ranks

  def self.today
    where(:created_at => (Date.today + 0.hours)..(Date.today + 23.hours + 59.minutes))
  end

  def winners
    (outcomes.select { |outcome| outcome.win }).collect {|outcome| outcome.player }
  end
  
  def losers
    (outcomes.select { |outcome| outcome.loss }).collect { |outcome| outcome.player }
  end

  private

  def is_singles_game?
    winners.size < 2
  end

  def update_ranks
    if is_singles_game?
      update_singles_ranks
    else
      update_doubles_ranks
    end
  end

  def update_singles_ranks
    winner = winners.first
    loser  = losers.first
    winner.wins!(loser, loser_score)
    loser.loses!(winner, loser_score)
  end

  def update_doubles_ranks
    winner1,winner2 = winners
    loser1,loser2 = losers
    winner1.wins_doubles!(:partner => winner2, :opponents => [loser1, loser2], :loser_score => loser_score)
    winner2.wins_doubles!(:partner => winner1, :opponents => [loser1, loser2], :loser_score => loser_score)
    loser1.loses_doubles!(:partner => loser2, :opponents => [winner1, winner2], :loser_score => loser_score)
    loser2.loses_doubles!(:partner => loser1, :opponents => [winner1, winner2], :loser_score => loser_score)
  end

end
