class CreateDoublesGames < ActiveRecord::Migration
  def change
    create_table :doubles_games do |t|
      t.belongs_to :winner1
      t.belongs_to :winner2
      t.belongs_to :loser1
      t.belongs_to :loser2

      t.timestamps
    end
    add_index :doubles_games, :winner1_id
    add_index :doubles_games, :winner2_id
    add_index :doubles_games, :loser1_id
    add_index :doubles_games, :loser2_id
  end
end
