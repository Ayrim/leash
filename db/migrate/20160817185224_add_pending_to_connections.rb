class AddPendingToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :is_pending, :boolean, :default => true
  end
end
