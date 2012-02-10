require 'spec_helper'

describe Player do
  context "requires email" do
    Given(:player) { Player.new }
    Then { player.should have(1).error_on(:email) }
  end

  context "must have unique email" do
    Given(:player) { Player.create!(:email => "bob@example.com", :rank => "500") }
    When(:dup) { Player.new(:email => player.email) }
    Then { dup.should have(1).error_on(:email) }
  end

  context "#games" do
    Given(:player_a) { Player.create(:email => "a@example.com", :rank => 750) }
    Given(:player_b) { Player.create(:email => "b@example.com", :rank => 750) }
    When(:game1) { Game.create(:outcomes => [Outcome.create(:player => player_a, :win => true),
                                              Outcome.create(:player => player_b, :win => false)],
                                :loser_score => 5 )}
    When(:game2) { Game.create(:outcomes => [Outcome.create(:player => player_a, :win => true),
                                              Outcome.create(:player => player_b, :win => false)],
                               :loser_score => 4 )}
    # sorted most recent first
    Then { player_a.games.should == [game2, game1] }
  end

  context "#new_rank" do
    Given(:player) { Player.new(:rank => 1800) }
    context "winning" do
      Then { player.new_rank(1550, 1).should == 1818 }
    end

    context "losing" do
      Then { player.new_rank(1550, 0).should == 1768 }
    end

    context "with scores" do
      Then { player.new_rank(1550, 0.9).should == 1813 }      
    end
  end

  context "#wins!" do
    Given(:player_a) { Player.create(:rank => 1800, :email => "a@example.com") }
    Given(:player_b) { Player.create(:rank => 1550, :email => "b@example.com") }
    Given(:loser_score) { 0 }
    When { player_a.wins!(player_b, loser_score) }
    Then { player_a.rank.should == 1818 }

    context "with scores" do
      Given(:loser_score) { 1 }
      Then { player_a.rank.should == 1813 } 
    end
  end

  context "#new_doubles_rank" do
    Given(:player) { Player.new(:doubles_rank => 2070) }
    Given(:partner) { Player.new(:doubles_rank => 1940) }
    Given(:opponent1) { Player.new(:doubles_rank => 1495) }
    Given(:opponent2) { Player.new(:doubles_rank => 1315) }
    context "winning" do
      Then { player.new_doubles_rank(:partner => partner, :opponents => [opponent1, opponent2], :score => 1).should == 2080 }
      Then { partner.new_doubles_rank(:partner => player, :opponents => [opponent1, opponent2], :score => 1).should == 1950 }
    end
    context "losing" do
      Then { player.new_doubles_rank(:partner => partner, :opponents => [opponent1, opponent2], :score => 0).should == 2030 }
      Then { partner.new_doubles_rank(:partner => player, :opponents => [opponent1, opponent2], :score => 0).should == 1900 }
    end
  end
  
  context "#win_expectancy" do
    Given(:player) { Player.new }
    Given(:data) { [[0, 50, 50],[25, 51, 49],[50, 53, 47],[75, 54, 46],[100, 56, 44],[150, 59, 41],[200, 61, 39],[250, 64, 36],[300, 67, 33],[350, 69, 31],[400, 72, 28],[450, 74, 26],[500, 76, 24],[600, 80, 20],[700, 83, 17],[800, 86, 14],[900, 89, 11],[1000, 91, 9],[1100, 93, 7],[1200, 94, 6],[1300, 95, 5],[1400, 96, 4],[1500, 97, 3],[1600, 98, 2],[1700, 98, 2],[1900, 99, 1],[2000, 99, 1],[2100, 99, 1],[2200, 99, 1 ]] }
    Then do
      data.each do |test|
        player.win_expectancy(test[0]).should be_within(0.005).of(test[1].to_f/100)
      end
    end
  end

  context "singles stats" do
    Given(:player) { Player.new( :rank => 500, :email => 'a@b.c' ) }
    context "initially" do
      Then { player.singles_wins.count.should == 0 }
      Then { player.singles_losses.count.should == 0 }
    end
    context "after a game" do
        Given(:opponent) { Player.new( :rank => 500, :email => 'x@y.z' ) }
        Given!(:game) { Game.create( :outcomes => [ Outcome.create( :player => player, :win => 1 ),
                                                    Outcome.create( :player => opponent, :win => 0)])}
        Then { player.singles_wins.count.should == 1 }
        Then { opponent.singles_losses.count.should == 1 }
    end
  end

  context "doubles stats" do
    Given(:player) { Player.new(:rank => 500, :email => 'a@b.c') }
    Given(:partner) { Player.new(:rank => 500, :email => 'b@c.d') }
    context "initially" do
      Then { player.doubles_wins.count.should == 0 }
      Then { partner.doubles_wins.count.should == 0 }
      Then { player.doubles_losses.count.should == 0 }
      Then { partner.doubles_losses.count.should == 0 }
    end
    context "after a game" do
        Given(:opponent) { Player.new(:rank => 500, :email => 'x@y.z') }
        Given(:opponent_partner) { Player.new(:rank => 500, :email => 'w@x.y') }
        Given!(:game) { DoublesGame.create( :winner1 => player, :winner2 => partner, :loser1 => opponent, :loser2 => opponent_partner ) }
        Given!(:game) { Game.create( :outcomes => [ Outcome.create( :player => player, :win => 1 ),
                                                    Outcome.create( :player => partner, :win => 1 ),
                                                    Outcome.create( :player => opponent, :win => 0 ),
                                                    Outcome.create( :player => opponent_partner, :win => 0)])}
        Then { player.doubles_wins.count.should == 1 }
        Then { partner.doubles_wins.count.should == 1 }
        Then { opponent.doubles_losses.count.should == 1 }
        Then { opponent_partner.doubles_losses.count.should == 1 }
    end
  end

end
