class Command < ActiveRecord::Base
  belongs_to :user
  attr_accessible :ran_at, :str
end
