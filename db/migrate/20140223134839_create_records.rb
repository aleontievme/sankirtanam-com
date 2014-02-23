class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :report, index: true
      t.string :distributor
      t.integer :mahabig
      t.integer :big
      t.integer :medium
      t.integer :small
      t.integer :journal
    end
  end
end
