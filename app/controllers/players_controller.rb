class PlayersController < InheritedResources::Base
  respond_to :html, :json

  helper_method :recent_games, :scores_over_time, :other_players

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

  def build_resource
    rp = resource_params
    if rp[0].has_key?(:rank)
      rp[0][:doubles_rank] ||= rp[0][:rank]
    else
      rp[0].update({ :rank => 750, :doubles_rank => 750 })
    end
    @player ||= Player.new(*rp)
  end

  def scores_over_time
    @player.score_history[-50,50]
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
