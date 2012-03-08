class GamesController < InheritedResources::Base
  respond_to :html, :json

  def index
    @games = Game.order('created_at desc').includes(:participants)
  end

  def new
    @game = Game.new
    params[:participant_pairs].to_i.times { @game.participants.build } 
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
