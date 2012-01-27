class DoublesGame < ActiveRecord::Base
  belongs_to :winner1, :class_name => "Player"
  belongs_to :winner2, :class_name => "Player"
  belongs_to :loser1, :class_name => "Player"
  belongs_to :loser2, :class_name => "Player"

  before_create :update_ranks

  def self.today
    where(:created_at => (Date.today + 0.hours)..(Date.today + 23.hours + 59.minutes))
  end

  private

  def update_ranks
    winner1.wins_doubles!(:partner => winner2, :opponents => [loser1, loser2])
    winner2.wins_doubles!(:partner => winner1, :opponents => [loser1, loser2])
    loser1.loses_doubles!(:partner => loser2, :opponents => [winner1, winner2])
    loser2.loses_doubles!(:partner => loser1, :opponents => [winner1, winner2])
  end

end
