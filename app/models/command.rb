class Command < ActiveRecord::Base
  belongs_to :user
  attr_accessible :ran_at, :str
	has_many :tokens

	def save_tokens
		token_strs = self.str.split( /\s+/ )  
		token_strs.each_with_index do |token_str,i|
			self.tokens.create( :position => i, :str => token_str ) 
		end
	end

end
