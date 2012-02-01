class CreateGameOutcome < ActiveRecord::Migration
  def change
    create_table :game_outcomes do |t|
      t.belongs_to :player
      t.belongs_to :game
      t.column :win, :boolean 
      t.timestamps
    end
    add_index :game_outcomes, :player_id
    add_index :game_outcomes, :game_id
  end
end
