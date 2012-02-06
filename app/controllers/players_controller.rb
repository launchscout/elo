class PlayersController < InheritedResources::Base
  respond_to :html, :json

  helper_method :recent_games, :scores_over_time, :other_players

  def create
    @player = Player.new(params[:player])
    @player.doubles_rank = @player.rank
    @player.save
    respond_to do |format|
      format.html { redirect_to players_path }
    end
  end

  def update
    super do |format|
      format.html { redirect_to players_path }
    end
  end

  private

  def build_resource
    @player ||= Player.new(:rank => 500)
  end

  def scores_over_time
    @player.score_history
  end

  def collection
    @players ||= Player.by_rank
  end

  def recent_games
    (Game.all).sort_by(&:created_at).reverse
  end

  def other_players
    Player.all(:order => "rank DESC") - [@player]
  end
end
