class AddDefaultLeagueData < ActiveRecord::Migration
  def up
    # create the Unicorn Office league
    # update all of the games 
    # create join table records for each player and league
    league = League.create(name: "Unicorn Office")
    Game.all.each do |g|
      g.update_attributes!(league_id: league.id)
    end
    Player.all.each do |p|
      p.update_attributes!(league_ids: [league.id])
    end
  end

  def down
    Game.all.each do |g|
      g.update_attributes!(league_id: nil)
    end
    Player.all.each do |p|
      p.update_attributes!(league_ids: [])
    end
    League.destroy_all
  end
end
