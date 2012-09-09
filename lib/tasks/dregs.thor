require "./config/environment"
class Dregs < Thor

	desc "setup", "setup 'dregs' for global use on this system"
	def setup( email )

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
			f.puts "alias dregs=\"history > ~/.dregs_history; thor dregs:load_history #{email}; thor dregs:execute #{email}\""
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

	desc "execute", "load new command line history, parse arguments and options"
	def execute( email, search = nil )
		user = User.where( :email => email ).first
		raise "Unknown User Email: #{email}" if user.nil?
		puts "Hello: #{user.email}".green
		puts "Searching for: #{search}" unless search.nil?
	end

	desc "load_history", "load history from ~/.dregs_history"
	def load_history( email )
		user = User.where( :email => email ).first
		raise "Unknown User Email: #{email}" if user.nil?

		history_file = File.join( ENV["HOME"], ".dregs_history" ) 
		raise "Can't Find: #{history_file}, did you run setup" unless File.file? history_file

		command_strings = File.open( history_file, "r" ).readlines
		
		new_commands = 0
		command_strings.each do | command_string |
			command_string.gsub!( /^\s+\d+\s+/, '' )
			time_string = command_string[ /^\[\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\]/ ]
			time_string.gsub!( /(\[|\])/, '' )
			command_string.gsub!( /^\[.+\]\s/,'' )
			ran_at = DateTime.strptime( time_string, '%Y-%m-%d %H:%M:%S' ).to_time
			
			if user.commands.where( :str => command_string, :ran_at => ran_at ).first.nil?
				command = user.commands.create( :str => command_string, :ran_at => ran_at )
				new_commands += 1 
			end
		end
		puts "New Commands: #{new_commands}".red
				
	end
end
