class User < ActiveRecord::Base
  attr_accessible :email, :handle, :passcode

=begin
	def setup_user( fields = {} )
		user = User.where( fields ).first
		if user.nil?
			user = User.new
			user.handle = args[:handle] if args.has_key? :handle
			user.email = args[:email] if args.has_key? :email
			user.passcode = args[:passcode] if args.has_key? :passcode
			user.save
			puts "User [email=#{user.email}] created".green
		else
			puts "User [email=#{user.email}] already existed".yellow
		end
	end
=end
end
