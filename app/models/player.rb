class Player < ActiveRecord::Base

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
      if audit.audited_changes.has_key?("rank")
        history << {:rank => audit.audited_changes["rank"][1], :date => audit.created_at}
      end
    end
    history
  end

  def games
    Game.all.select { |game| game.outcomes.any? { |outcome| outcome.player == self }}
  end

  def singles_wins
    Outcome.singles_wins.select { |outcome| outcome.player == self }
  end

  def singles_losses
    Outcome.singles_losses.select { |outcome| outcome.player == self }
  end

  def doubles_wins
    Outcome.doubles_wins.select { |outcome| outcome.player == self }
  end

  def doubles_losses
    Outcome.doubles_losses.select { |outcome| outcome.player == self }
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

  def wins!(opponent, loser_score = 0)
    update_attributes!(:rank => new_rank(opponent.rank, (10.0/(10.0+ loser_score))))
  end

  def loses!(opponent, loser_score = 0)
    update_attributes!(:rank => new_rank(opponent.rank, (loser_score.to_f/(10.0+ loser_score))))
  end

  def wins_doubles!(params = {})
    update_attributes!(:doubles_rank => new_doubles_rank(params.merge(:score => (10.0/(10.0+ params[:loser_score])))))
  end

  def loses_doubles!(params = {})
    update_attributes!(:doubles_rank => new_doubles_rank(params.merge(:score => (params[:loser_score].to_f/(10.0+ params[:loser_score]))))) 
  end

  private

  def set_doubles_rank
    self.doubles_rank ||= self.rank
  end
end
