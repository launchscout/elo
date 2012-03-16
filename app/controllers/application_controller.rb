class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :active_league
  before_filter :load_players

  private

  def active_league
    League.first
  end

  def load_players
    @players ||= Player.all(:order => "rank DESC")
  end
end
