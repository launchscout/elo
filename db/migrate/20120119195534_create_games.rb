class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.belongs_to :winner
      t.belongs_to :loser

      t.timestamps
    end
  end
end
