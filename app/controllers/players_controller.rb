class PlayersController < InheritedResources::Base
  respond_to :html, :json

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
end
