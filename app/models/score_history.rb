class ScoreHistory
  attr_accessor :player, :game
  
  def initialize(player)
    self.player = player
  end

  def history
    return @history unless @history.blank?
    @history = []
    audits.each do |audit|
      changes = audit.audited_changes
      entry = { :date => audit.created_at, }
      if changes.has_key?("last_game_id")
        game = Game.find(changes["last_game_id"][-1])
        entry[:date] = game.created_at
        entry[:desc] = game.plain_display
        entry[:winners] = game.winner_names
        entry[:losers] = game.loser_names
        entry[:margin] = game.margin
      end

      if changes.has_key?("rank")
        new, old = changes["rank"]
        entry[:rank] = new
      elsif changes.has_key?("doubles_rank")
        new, old = changes["doubles_rank"]
        entry[:doubles_rank] = new
      end
      entry[:change] = new - old
      @history << entry
    end
    @history
  end

  def audits
    @audits ||= Audit.where(:auditable_id => player.id).select do |audit|
      (changes = audit.audited_changes).has_key?("rank") || changes.has_key?("doubles_rank")
    end
  end
end
