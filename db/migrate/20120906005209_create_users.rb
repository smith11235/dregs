class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :handle
      t.string :passcode

      t.timestamps
    end
  end
end
