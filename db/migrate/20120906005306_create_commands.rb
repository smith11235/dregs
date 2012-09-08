class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.references :user
      t.string :str
      t.datetime :ran_at

      t.timestamps
    end
    add_index :commands, :user_id
  end
end
