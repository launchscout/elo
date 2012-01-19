class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :email
      t.integer :rank
      t.string :name

      t.timestamps
    end
  end
end
