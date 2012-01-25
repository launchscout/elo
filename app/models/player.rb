class Player < ActiveRecord::Base

  validates_uniqueness_of :email
  validates_presence_of :email, :rank, :doubles_rank
  
  before_validation :set_doubles_rank
  
  def display_name
    name.blank? ? email : name.gsub(/ (.*)$/) { " " + $&.split(//)[1] + "." }
  end

  def self.by_rank
    order('rank desc')
  end

  def games
    (Game.where("winner_id = :id OR loser_id = :id", {:id => id}).order('created_at desc') +
     DoublesGame.where("winner1_id = :id OR winner2_id = :id OR loser1_id = :id OR loser2_id = :id", {:id => id}).order('created_at desc')).sort_by(&:created_at).reverse
  end

  def singles_wins
    Game.find_all_by_winner_id( id ).count 
  end

  def singles_losses
    Game.find_all_by_loser_id( id ).count 
  end

  def doubles_wins
    DoublesGame.find_all_by_winner1_id( id ).count + DoublesGame.find_all_by_winner2_id( id ).count 
  end

  def doubles_losses
    DoublesGame.find_all_by_loser1_id( id ).count + DoublesGame.find_all_by_loser2_id( id ).count 
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
