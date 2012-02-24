class RenameOutcomeToParticipant < ActiveRecord::Migration
  def change
    rename_table :outcomes, :participants
  end
end
