class AddCaptionToRecords < ActiveRecord::Migration
  def change
    add_column :records, :caption, :string
  end
end
