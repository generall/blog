class AddUrlNameToRecords < ActiveRecord::Migration
  def change
    add_column :records, :url_name, :string, :index => true
  end
end
