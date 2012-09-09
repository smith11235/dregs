class User < ActiveRecord::Base
  attr_accessible :email, :handle, :passcode

	has_many :commands
end
