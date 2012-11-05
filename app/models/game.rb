class Game < ActiveRecord::Base
  has_many :participants, :dependent => :destroy
  has_many :winners, :through => :participants, :source => :player, :conditions => {"participants.win" => true}
  has_many :losers, :through => :participants, :source => :player, :conditions => {"participants.win" => false}
  belongs_to :league

  accepts_nested_attributes_for :participants

  after_create :count_participants
  after_create :update_ranks
  after_destroy :remove_audits

  def self.today
    where(:created_at => (Date.today + 0.hours)..(Date.today + 23.hours + 59.minutes))
  end

  def self.singles
    where(:participant_count => 2)
  end

  def self.doubles
    where(:participant_count => 4)
  end
  
  def plain_display
    "#{winner_names} beat #{loser_names} by #{margin} on #{created_at}"
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
  
  def is_singles_game?
    participant_count == 2
  end
  
  def update_ranks
    rank = (participant_count == 2) ? :rank : :doubles_rank
    winners_rank = winners.map { |w| w.send(rank) }.sum.to_f / winners.count
    losers_rank = losers.map { |w| w.send(rank) }.sum.to_f / losers.count
    winners.each { |winner| winner.update_rank!(:opponent_rank => losers_rank,
                                                :my_rank => winners_rank,
                                                :score => percentage_of_points_winning,
                                                :game => self,
                                                :attr => rank) }
    losers.each { |loser|    loser.update_rank!(:opponent_rank => winners_rank,
                                                :my_rank => losers_rank,
                                                :score => percentage_of_points_losing,
                                                :game => self,
                                                :attr => rank) }
  end

  def percentage_of_points_winning
    10.0 / (10.0 + loser_score.to_f)
  end

  def percentage_of_points_losing
    loser_score.to_f / (10.0 + loser_score.to_f)
  end

  private

  def count_participants
    update_attributes(:participant_count => participants(true).count)
  end

  def remove_audits
    # There's no direct tie between a player's audits and this game except through "last_game_id"
    # So we have to purge all the audits related to this game so that the graphs can be drawn
    audits = Audit.find_by_sql("select * from audits where audited_changes like '%#{id}%'")
    audits.select { |a| a.audited_changes["last_game_id"].include?(id) }.map(&:delete)
  end
end
