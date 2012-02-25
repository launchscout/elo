require 'spec_helper'

describe HistoricalGame do
  Given(:player) { Player.create(:email => "a@b.c",
                                 :rank => 750,
                                 :created_at => 5.days.ago) }
  Given(:audit) { player.audits.last }
  Given(:game) { Game.create(:created_at => 2.days.ago) }
  Given(:historical_game) { HistoricalGame.new(player, audit) }
  context "#date" do
    Then { historical_game.date.should == audit.created_at }

    context "with an associated game" do
      Given { flexmock(historical_game).should_receive(:new_value).with("last_game_id").and_return(game.id) }
      Then { historical_game.date.should == game.created_at }
    end
  end

  context "with a change in score" do
    When { player.update_attributes(:rank => 800) }
    Then { historical_game.change.should == 50 }
  end

  context "ranking going down" do
    When { player.update_attributes(:rank => 700) }
    Then { historical_game.change.should == -50 }
  end
end
