class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :total_time
      t.string :tag
      t.integer :work_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
