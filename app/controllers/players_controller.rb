class PlayersController < InheritedResources::Base
  respond_to :html, :json

  helper_method :recent_games

  def create
    super do |format|
      format.html { redirect_to players_path }
    end
  end

  def update
    super do |format|
      format.html { redirect_to players_path }
    end
  end

  private

  def collection
    @players ||= Player.by_rank
  end

  def recent_games
    (Game.all + DoublesGame.all).sort_by(&:created_at).reverse
  end
end
