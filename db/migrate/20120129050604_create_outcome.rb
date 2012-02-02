class CreateOutcome < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
      t.belongs_to :player
      t.belongs_to :game
      t.column :win, :boolean 
      t.timestamps
    end
    add_index :outcomes, :player_id
    add_index :outcomes, :game_id
  end
end
