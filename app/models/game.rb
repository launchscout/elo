class Game < ActiveRecord::Base
  has_many :participants, :dependent => :destroy
  has_many :winners, :through => :participants, :source => :player, :conditions => {"participants.win" => true}
  has_many :losers, :through => :participants, :source => :player, :conditions => {"participants.win" => false}

  accepts_nested_attributes_for :participants

  after_create :update_ranks
  after_create :count_participants

  def self.today
    where(:created_at => (Date.today + 0.hours)..(Date.today + 23.hours + 59.minutes))
  end

  def winner_names
    winners.map(&:display_name).join(', ')
  end

  def loser_names
    losers.map(&:display_name).join(', ')
  end

  def margin
    10 - loser_score
  end
  
  def plain_display
    "#{winner_names} beat #{loser_names} by #{margin} on #{created_at}"
  end

  private

  def self.singles
    where(:participant_count => 2)
  end

  def self.doubles
    where(:participant_count => 4)
  end
  
  def is_singles_game?
    participant_count == 2
  end
  
  def update_ranks
    if participant_count == 2
      Rails.logger.debug("updating ranks for singles game")
      update_singles_ranks
    elsif participant_count == 4
      Rails.logger.debug("updating ranks for double game")
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

  def count_participants
    update_attributes(:participant_count => participants(true).count)
  end
end
