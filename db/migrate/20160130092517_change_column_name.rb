class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :records, :type, :rtype
  end
end
