class CreateTurns < Jennifer::Migration::Base
  def up
    create_table :turns do |t|
      t.string :game_id, {:null => false}

      t.timestamps
    end
  end

  def down
    drop_table :turns if table_exists? :turns
  end
end