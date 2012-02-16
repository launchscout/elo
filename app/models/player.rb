class Player < ActiveRecord::Base

  has_many :outcomes
  has_many :games, :through => :outcomes, :order => "created_at DESC"
  
  acts_as_audited :except => [:email, :name]

  validates_uniqueness_of :email
  validates_presence_of :email, :rank, :doubles_rank
  
  before_validation :set_doubles_rank
  
  def display_name
    name.blank? ? email : name.gsub(/ (.*)$/) { " " + $&.split(//)[1] + "." }
  end

  def self.by_rank
    order('rank desc')
  end

  def score_history
    history = []
    Audit.where(:auditable_id => self.id).each do |audit|
      if (changes = audit.audited_changes).has_key?("rank") || changes.has_key?("doubles_rank")
        entry = { :date => audit.created_at, }
        entry[        :rank] = Array(changes[        "rank"])[-1] if changes.has_key?(        "rank")
        entry[:doubles_rank] = Array(changes["doubles_rank"])[-1] if changes.has_key?("doubles_rank")
        history << entry
      end
    end
    history
  end

  delegate :singles_wins, :doubles_wins, :singles_losses, :doubles_losses, :to => :outcomes

  def new_rank(opponent_rank, score, avg_rank = nil, attr = :rank)
    avg_rank ||= rank
    self.send(attr) + (K_RATING_COEFFICIENT*(score - win_expectancy(avg_rank - opponent_rank))).round
  end

  def new_doubles_rank(params = {})
    opponent_rank = params[:opponents].map(&:doubles_rank).inject(0.0) { |sum,rank| sum + rank }.to_f / 2.0
    avg_rank = (doubles_rank + params[:partner].doubles_rank).to_f/2.0
    new_rank(opponent_rank, params[:score], avg_rank, :doubles_rank)
  end

  def win_expectancy(diff)
    1 / ( 10**(-diff.to_f/F_RATING_INTERVAL_SCALE_WEIGHT.to_f) + 1)
  end

  def margin(player)
    # percentage of points scored needs to exceed We for your rank to go up.
    we = win_expectancy(rank - player.rank)
    if we > 0.50
      # greater than even odds to win
      10 - ((10.0 - 10.0*we) / we).round
    else
      # less than even odds to win
      ((10.0*we)/(1.0 - we)).round - 10
    end
  end
  
  def wins!(opponent, loser_score = 0)
    update_attributes!(:rank => new_rank(opponent.rank, percentage_of_points_winning(loser_score)))
  end

  def loses!(opponent, loser_score = 0)
    update_attributes!(:rank => new_rank(opponent.rank, percentage_of_points_losing(loser_score)))
  end

  def wins_doubles!(params = {})
    update_attributes!(:doubles_rank =>
                       new_doubles_rank(params.merge(:score => percentage_of_points_winning(params[:loser_score]))))
  end

  def loses_doubles!(params = {})
    update_attributes!(:doubles_rank =>
                       new_doubles_rank(params.merge(:score => percentage_of_points_losing(params[:loser_score])))) 
  end

  def percentage_of_points_winning(loser_score = 0.0)
    10.0 / (10.0 + loser_score.to_f)
  end

  def percentage_of_points_losing(loser_score = 0.0)
    loser_score.to_f / (10.0 + loser_score.to_f)
  end

  private

  def set_doubles_rank
    self.doubles_rank ||= self.rank
  end
end
