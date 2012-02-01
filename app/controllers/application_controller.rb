class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_players

  private

  def load_players
    @players ||= Player.all(:order => "rank DESC")
  end
end
