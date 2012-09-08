class Token < ActiveRecord::Base
  belongs_to :command
  attr_accessible :position, :str
end
