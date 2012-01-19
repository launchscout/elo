class Player < ActiveRecord::Base

  validates_uniqueness_of :email
  validates_presence_of :email

  has_many :wins, :class_name => "Game", :foreign_key => :winner_id, :dependent => :destroy
  has_many :loses, :class_name => "Game", :foreign_key => :loser_id, :dependent => :destroy

  def display_name
    name.blank? ? email : name
  end

  def self.by_rank
    order('rank desc')
  end

  def games
    (wins + loses).sort_by(&:created_at)
  end

  def new_rank(opponent_rank, score)
    rank + (K_RATING_COEFFICIENT*(score - win_expectancy(rank - opponent_rank))).round
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

end
