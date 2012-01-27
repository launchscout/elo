class Game < ActiveRecord::Base
  belongs_to :winner, :class_name => "Player"
  belongs_to :loser, :class_name => "Player"

  before_create :update_ranks

  def self.today
    where(:created_at => (Date.today + 0.hours)..(Date.today + 23.hours + 59.minutes))
  end

  private

  def update_ranks
    winner.wins!(loser)
    loser.loses!(winner)
  end
end
