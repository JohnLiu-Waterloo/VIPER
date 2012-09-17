class CreateCloseRelations < ActiveRecord::Migration
  def change
    create_table :close_relations do |t|
      t.integer :userid
      t.integer :r0
      t.integer :r1
      t.integer :r2
      t.integer :r3
      t.integer :r4
      t.integer :r5
      t.integer :r6
      t.integer :r7
      t.integer :r8
      t.integer :r9

      t.timestamps
    end
  end
end
