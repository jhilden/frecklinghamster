class AddExportedAtFieldToFacts < ActiveRecord::Migration
  def change
    add_column :facts, :exported_at, :timestamp
  end
end
