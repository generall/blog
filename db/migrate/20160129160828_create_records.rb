class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :name, :index => true
      t.string :file
      t.datetime :time
      t.string :snippet

      t.timestamps null: false
    end
  end
end
