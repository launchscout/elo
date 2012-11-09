class GamesController < InheritedResources::Base
  respond_to :html, :json

  def index
    @games = Game.order('created_at desc').includes(:participants).limit(25)
  end

  def new
    @game = Game.new
    params[:participant_pairs].to_i.times { @game.participants.build } 
  end

  def create
    params[:game][:loser_score] = "#{params[:game][:loser_score].to_i * 2}"
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
