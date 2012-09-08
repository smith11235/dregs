class Dregs < Thor

	desc "setup", "setup 'dregs' for global use on this system"
	def setup( email )
		require "./config/environment"

		puts "Installing Dregs".yellow
		user = User.where( :email => email ).first
		if user.nil?
			puts " - Creating user"
			user = User.new
			user.email = email
			user.save
		end

		puts " - Creating ~/.dregs"
		init_script = File.join( ENV["HOME"], ".dregs" )
		File.open( init_script, "w" ) do |f|
			f.puts "echo 'setting up dregs'"
			f.puts "export TTY_NAME=`tty|sed -e 's|/dev/||' -e 's|/|_|'`"
			f.puts "export HISTFILESIZE=\"3000\""
			f.puts "export HISTTIMEFORMAT=\"[%Y-%m-%d %H:%M:%S] \""
			f.puts "export HISTFILE=\"$HOME/.bash_history_$TTY_NAME\""
			f.puts "alias dregs=\"history > ~/.dregs_history; thor dregs:execute #{email}\""
		end

		init_command = "source #{init_script}"

		profile = File.join( ENV["HOME"], ".profile" ) 
		File.open( profile, "a" ) do |f|
			f.puts init_command 
		end

		puts "After next login, remember to run '$ dregs' often".red
		puts "Run '$ source ~/.dregs' to setup now".red
		puts "Command setup for: #{user.email}".green
	end


end
