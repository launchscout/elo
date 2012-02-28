desc "throw out the current past rankings, recalculate based on game history (initial_score defaults to 750)"
task :rescore, [:initial_score] => :environment do |t, args|
  initial_score = args.initial_score || 750
  Audit.delete_all

  Player.all.each do |player|
    player.update_attributes({ :rank => initial_score, :doubles_rank => initial_score, :last_expected_margin => 0 })
    player.save
  end

  Game.order("created_at ASC, id ASC").each { |g| g.update_ranks }
  
end
