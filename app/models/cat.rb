class Cat < ActiveRecord::Base
  has_many :record
  
  def records
    record
  end
end
