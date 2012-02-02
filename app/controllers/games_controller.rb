class GamesController < InheritedResources::Base
  respond_to :html, :json

  def new
    @game = Game.new
    params[:outcome_pairs].to_i.times { @game.outcomes.build } 
  end

  def create
    super do |format|
      format.html { redirect_to players_path }
    end
  end

  def destroy
    super do |format|
      format.html { redirect_to players_path }
    end
  end    
end
