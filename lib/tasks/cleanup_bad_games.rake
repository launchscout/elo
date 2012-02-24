
desc "Our games, outcomes, early games with no scores are all out of whack. Delete them"
task :cleanup_old_games => [:environment] do
  stale_game_ids_on_participations = [106, 107, 108, 109, 110, 112, 113, 120, 121, 126, 131, 137, 142, 148]
  stale_game_ids_with_scores = [1, 4, 5, 7, 8, 12, 14, 15, 20, 21, 22, 27, 31, 34, 35, 38, 39, 42, 43, 44, 48, 51, 54, 55, 56, 63, 65, 69, 72, 73, 74, 76, 78, 79, 80, 81, 84, 85, 86, 91, 92, 95, 97, 101, 104]
  stale_game_id_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 6, 1, 8, 4, 3, 6, 3, 7, 6, 6, 3, 5, 9, 8, 5, 8, 3, 9, 0, 6, 3]
  started_scoring_games_on = DateTime.parse("2012-01-27 13:52:57 +0:00")

  # begin by creating games that we have scores for
  stale_game_ids_with_scores.each_with_index do |id, index|
    next if Game.find_by_id(id)
    g = Game.new(:loser_score => stale_game_id_scores[index])
    g.id = id
    g.save!
  end

  # delete the participations that have stale game ids
  Participant.find_each do |participant|
    participant.delete unless participant.game
  end

  # delete all games from before we started tracking the score
  Participant.where(["created_at < ?", started_scoring_games_on]).each do |p|
    Game.destroy(p.game_id) rescue nil
  end
end
