class ScoreHistory
  attr_accessor :player, :game
  
  def initialize(player)
    self.player = player
  end

  def history
    @historical_games ||=
      audits.map { |a| HistoricalGame.new(player, a) }
  end

  def audits
    @audits ||= player.audits.select do |audit|
      audit.audited_changes.has_key?("last_game_id")
    end
  end
end
