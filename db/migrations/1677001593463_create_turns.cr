class CreateTurns < Jennifer::Migration::Base
  def up
    create_table :turns do |t|
      t.string :game_id, {:null => false}
      t.string :snake_id, {:null => false}
      t.text :context, {:null => false}
      t.string :path, {:null => false}
      t.bool :dead, {:null => false, :default => false}

      t.index :game_id
      t.index :path

      t.timestamps
    end
  end

  def down
    drop_table :turns if table_exists? :turns
  end
end