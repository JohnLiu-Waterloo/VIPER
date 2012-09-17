class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.boolean :f0
      t.boolean :f1
      t.boolean :f2
      t.boolean :f3
      t.boolean :f4
      t.boolean :f5
      t.boolean :f6
      t.boolean :f7
      t.boolean :f8
      t.boolean :f9
      t.boolean :f10
      t.boolean :f11
      t.boolean :f12
      t.boolean :f13
      t.boolean :f14
      t.boolean :f15
      t.boolean :f16
      t.boolean :f17
      t.boolean :f18
      t.boolean :f19
      t.boolean :f20
      t.boolean :f21
      t.boolean :f22
      t.boolean :f23
      t.boolean :f24

      t.timestamps
    end
  end
end
