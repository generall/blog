class AddTypeToRecord < ActiveRecord::Migration
  def change
    add_column :records, :type, :string
  end
end
