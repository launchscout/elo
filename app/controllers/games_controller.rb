class GamesController < InheritedResources::Base
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
