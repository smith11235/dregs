class Command < ActiveRecord::Base
  belongs_to :user
  attr_accessible :ran_at, :str

	def self.load_history( user_handle )
		Command.set_user( :handle => user_handle )

		puts "Coal User: #{@@user[:handle]}"
		history_file = File.join( ENV["HOME"], ".coal_history" ) 
		raise "Can't Find: #{history_file}, did you run setup" unless File.file? history_file

		original_commands = File.open( history_file, "r" ).readlines
		Command.save_commands( original_commands )
		 
	end

	def self.command_exists?( original )
		command = Command.where( [ "user_id = ? AND original = ?", $user.id, original ] ).first
		! command.nil?
	end

	def self.save_commands( original_commands )
		new_commands = 0
		i = 0
		puts "# commands to load: #{original_commands.size}"
		original_commands.each do |original_command|
			i += 1
			puts " - #{i}/#{original_commands.size}" if original_commands.size > 40 && i > 0 && i % ( original_commands.size / 7 ) == 0
			next if Command.command_exists?( original_command )	
			command = Command.new
			command.original = original_command 
			description = { "ENV" => { "TTY_NAME" => ENV["TTY_NAME"], "HISTFILE" => ENV["HISTFILE"] } }
			command.description = description.to_yaml 
			command.user_id = @@user.id
			command.save
			command.save_tokens
			new_commands += 1
		end
		puts "Loaded #{new_commands} new commands".green
	end

	def save_tokens
		raw_tokens = self.original.split( /\s+/ )  
		token_offset = 0
		raw_tokens.each do |raw_token|
			token = Token.new	
			token.command_id = self.id	
			token.offset = token_offset
			token.original = raw_token
			token.save
			token_offset += 1
		end
	end

end
