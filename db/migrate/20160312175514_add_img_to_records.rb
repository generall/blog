class AddImgToRecords < ActiveRecord::Migration
  def change
    add_column :records, :img, :string
  end
end
