class DenormalizePlayerCountOnGames < ActiveRecord::Migration

  class Game < ActiveRecord::Base
    has_many :participants
  end

  class Participant < ActiveRecord::Base
    belongs_to :game
  end
  
  def change
    add_column :games, :participant_count, :integer
    Game.reset_column_information
    Game.find_each do |game|
      game.update_attributes!(:participant_count => game.participants.count)
    end
  end
end
