class RecordManyToManyWithTags < ActiveRecord::Migration
  def change
    create_table :records_tags, id: false do |t|
      t.belongs_to :record, index: true
      t.belongs_to :tag, index: true
    end  
  end
end
