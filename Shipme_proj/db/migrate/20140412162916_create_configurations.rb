class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.float :comission

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
