class TrackExpectedMargin < ActiveRecord::Migration
  def change
    add_column :players, :last_expected_margin, :integer
  end
end
