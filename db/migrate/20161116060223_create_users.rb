class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :password
      t.integer :auth_type

      t.timestamps
    end
    add_index :users, :login, unique: true
  end
end
