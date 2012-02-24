task :rescore => :environment do
  all_games = []

  singles = Game.order('created_at').each do |game|
    if game.send(:is_singles_game?)
      all_games << {
        created_at:  game.created_at,
        winner:      game.winners[0].id,
        loser:       game.losers[0].id,
        loser_score: game.loser_score,
      }
    else
      all_games << {
        created_at:  game.created_at,
        winner1:     game.winners[0].id,
        winner2:     game.winners[1].id,
        loser1:      game.losers[0].id,
        loser2:      game.losers[1].id,
        loser_score: game.loser_score,
      }
    end
  end

  Audit.delete_all
  Game.delete_all
  Player.all.each do |player|
    player.update_attributes({ :rank => 750, :doubles_rank => 750, })
    player.save
  end

  # Ideally, this would adjust the create_at on the newly generated Audit
  # records so that the graph will have the times of the original games.
  last_known_audit_id = 0
  all_games.sort_by {|_|_[:created_at]}.each do |game_hash|
    if game_hash.has_key?(:winner) # Singles
      game = Game.new({
                        :outcomes => [
                                      Outcome.new({
                                                    :player => Player.find(game_hash[:winner]),
                                                    :win => true,
                                                  }) {|_| _.created_at = game_hash[:created_at] },
                                      Outcome.new({
                                                    :player => Player.find(game_hash[:loser]),
                                                    :win => false,
                                                  }) {|_| _.created_at = game_hash[:created_at] },
                                     ],
                        :loser_score => game_hash[:loser_score],
                      }) {|_| _.created_at = game_hash[:created_at] }
      game.save
    else
      game = Game.new({
                        :outcomes => [
                                      Outcome.new({
                                                    :player => Player.find(game_hash[:winner1]),
                                                    :win => true,
                                                  }) {|_| _.created_at = game_hash[:created_at] },
                                      Outcome.new({
                                                    :player => Player.find(game_hash[:winner2]),
                                                    :win => true,
                                                  }) {|_| _.created_at = game_hash[:created_at] },
                                      Outcome.new({
                                                    :player => Player.find(game_hash[:loser1]),
                                                    :win => false,
                                                  }) {|_| _.created_at = game_hash[:created_at] },
                                      Outcome.new({
                                                    :player => Player.find(game_hash[:loser2]),
                                                    :win => false,
                                                  }) {|_| _.created_at = game_hash[:created_at] },
                                     ],
                        :loser_score => game_hash[:loser_score],
                      }) {|_| _.created_at = game_hash[:created_at] }
      game.save
    end
    Audit.update_all({ created_at: game_hash[:created_at] }, ['id > ?', last_known_audit_id])
    last_known_audit_id = Audit.maximum(:id)
  end
end
