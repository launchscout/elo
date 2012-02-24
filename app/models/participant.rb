class Participant < ActiveRecord::Base
  belongs_to :game, :class_name => "Game"
  belongs_to :player, :class_name => "Player"

  def loss
    !self.win
  end

  def self.wins
    where(:win => true)
  end

  def self.losses
    where(:win => false)
  end

  def self.singles
    joins(:game).where("games.participant_count = 2")
  end

  def self.doubles
    joins(:game).where("games.participant_count = 4")
  end
end
