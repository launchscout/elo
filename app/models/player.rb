class Player < ActiveRecord::Base

  has_many :participations, :class_name => "Participant", :inverse_of => :player
  
  has_many :games, :through => :participations, :order => "created_at DESC"
  belongs_to :last_game, :class_name => "Game"
  
  acts_as_audited :except => [:email, :name]

  validates_uniqueness_of :email
  validates_presence_of :email, :rank, :doubles_rank
  
  before_validation :set_doubles_rank

  [:singles, :doubles].each do |count|
    define_method("#{count}_games") do
      participations.joins(:game).order("games.created_at DESC").send(count).map(&:game)
    end
    [:wins, :losses].each do |outcome|
      define_method("#{count}_#{outcome}") do
        participations.joins(:game).order("games.created_at DESC").send(outcome).send(count).map(&:game)
      end

      define_method(outcome) do
        participations.joins(:game).order("games.created_at DESC").send(outcome).map(&:game)
      end
    end
  end
  
  def display_name
    name.blank? ? email : name.gsub(/ (.*)$/) { " " + $&.split(//)[1] + "." }
  end

  def self.by_rank
    order('rank desc')
  end

  def score_history
    @score_history ||= ScoreHistory.new(self).history
  end

  def update_rank!(params = {})
    rank = params[:attr] || :rank
    update_attributes(rank => new_rank(params))
  end
  
  def new_rank(params = {});
    params[:attr] ||= :rank
    params[:my_rank] ||= rank
    Rails.logger.debug("Player #{name}#new_rank: #{params.inspect}")

    diff = params[:my_rank] - params[:opponent_rank]
    we = win_expectancy(diff)
    delta = (K_RATING_COEFFICIENT * (params[:score] -  we)).round
    Rails.logger.debug("Player #{name}#new_rank: #{delta} = (#{K_RATING_COEFFICIENT} * (#{params[:score]} - #{we}))")
    self.send(params[:attr]) + delta
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
  
  private

  def set_doubles_rank
    self.doubles_rank ||= self.rank
  end
end
