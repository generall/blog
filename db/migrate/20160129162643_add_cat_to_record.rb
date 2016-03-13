class AddCatToRecord < ActiveRecord::Migration
  def change
    add_reference :records, :cat, index: true, foreign_key: true
  end
end
