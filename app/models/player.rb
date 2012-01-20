class Player < ActiveRecord::Base

  validates_uniqueness_of :email
  validates_presence_of :email, :rank, :doubles_rank

  has_many :wins, :class_name => "Game", :foreign_key => :winner_id, :dependent => :destroy
  has_many :loses, :class_name => "Game", :foreign_key => :loser_id, :dependent => :destroy

  has_many :doubles_wins, :class_name => "DoublesGame", :foreign_key => :winner_id, :dependent => :destroy
  has_many :doubles_loses, :class_name => "DoublesGame", :foreign_key => :loser_id, :dependent => :destroy
  
  before_validation :set_doubles_rank
  
  def display_name
    name.blank? ? email : name
  end

  def self.by_rank
    order('rank desc')
  end

  def games
    (wins + loses + doubles_wins + doubles_loses).sort_by(&:created_at)
  end

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

  def wins!(opponent)
    update_attributes!(:rank => new_rank(opponent.rank, 1))
  end

  def loses!(opponent)
    update_attributes!(:rank => new_rank(opponent.rank, 0))
  end

  def wins_doubles!(params = {})
    update_attributes!(:doubles_rank => new_doubles_rank(params.merge(:score => 1)))
  end

  def loses_doubles!(params = {})
    update_attributes!(:doubles_rank => new_doubles_rank(params.merge(:score => 0))) 
  end

  private

  def set_doubles_rank
    self.doubles_rank ||= self.rank
  end
end
