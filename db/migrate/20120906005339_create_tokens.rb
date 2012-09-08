class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :command
      t.string :str
      t.integer :position

      t.timestamps
    end
    add_index :tokens, :command_id
  end
end
